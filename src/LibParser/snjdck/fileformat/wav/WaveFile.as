package snjdck.fileformat.wav
{
    import flash.debugger.enterDebugger;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.IDataInput;
    
    import snjdck.media.sound.ISoundSample;
    import snjdck.media.sound.MonoSample;
    import snjdck.media.sound.StereoSample;
    
	/**
	 * RIFF
	 * size(head + body)
	 * head(36)
	 * body
	 */
	final public class WaveFile
    {
        private static const RIFF_GROUP_ID		:String = "RIFF";
        private static const WAVE_TYPE			:String = "WAVE";
        private static const FORMAT_CHUNK		:String = "fmt ";
        private static const DATA_CHUNK			:String = "data";
        private static const SAMPLE_CHUNK		:String = "smpl";
        private static const INSTRUMENT_CHUNK	:String = "inst";
        private static const UNCOMPRESSED_FORMAT:int = 1;
        private static const HEADER_OFFSET		:int = 36;
        private static const SUBCHUNK_SIZE_PCM	:int = 16;
        private static const BYTE_LENGTH		:int = 8;
        
        /**
         * Given a WAV file in the form of a ByteArray, return a Sample
         * that includes its data.
         */
        public static function createSample(wav:ByteArray):ISoundSample
        {
            wav.endian = Endian.LITTLE_ENDIAN;
            const groupId:String = wav.readUTFBytes(4);
            if (groupId != RIFF_GROUP_ID){
                throw new Error("Invalid WAV group id: " + groupId);
            }

            const fileLen:uint = wav.readUnsignedInt() + 8;
            
            const riffType:String = wav.readUTFBytes(4);
            if (riffType != WAVE_TYPE){
                throw new Error("Invalid RIFF type; expected WAVE but found: " + riffType);
            }
            
			var soundSample:ISoundSample;
            var bitsPerSample:uint;
            var channels:uint;
            
            while(wav.bytesAvailable > 0)
            {
                var chunkType:String = wav.readUTFBytes(4);
                var chunkSize:uint = wav.readUnsignedInt();
                var chunkStart:uint = wav.position;
                if ((chunkSize % 2) == 1){
                   // wav spec says: round chunks to even bytes, so force to word boundary
                   chunkSize += 1;
                }
                        
                switch(chunkType)
                {
                    case FORMAT_CHUNK:
                        if(wav.readUnsignedShort() != UNCOMPRESSED_FORMAT){
                            throw new Error("Cannot handle compressed WAV data");
                        }
                        channels = wav.readUnsignedShort();
                        wav.readUnsignedInt();
                        wav.readUnsignedInt();
                        wav.readUnsignedShort();
                        bitsPerSample = wav.readUnsignedShort();
                        break;
                    case DATA_CHUNK:
						soundSample = readVoiceList(wav, chunkSize, bitsPerSample, channels);
						break;
                    case SAMPLE_CHUNK:
                    case INSTRUMENT_CHUNK:
                    	break;
                }
                wav.position = chunkStart + chunkSize;
            }
			
			return soundSample;
        }
		
		static private function readSample(bytes:IDataInput, bitsPerSample:uint):int
		{
			switch(bitsPerSample)
			{
				case 16:
					return bytes.readShort();
				case 8:
					return bytes.readByte();
				default:
					enterDebugger();
			}
			return 0;
		}
		
		static private function readVoiceList(bytes:IDataInput, chunkSize:uint, bitsPerSample:uint, channels:uint):ISoundSample
		{
			const voiceList:Vector.<Number> = new Vector.<Number>();
			
			const numSamples:uint = chunkSize / (bitsPerSample >> 3);
			const numFrames:int = numSamples / channels;
			
			const factor:Number = 1 / (1 << (bitsPerSample - 1));
			var voice:Number;
			for(var i:int=0; i<numFrames; i++)
			{
				voice = readSample(bytes, bitsPerSample) * factor;
				voiceList.push(voice);
				if(channels < 2){
					continue;
				}
				voice = readSample(bytes, bitsPerSample) * factor;
				voiceList.push(voice);
			}
			
			var cls:Class = (channels > 1) ? StereoSample : MonoSample;
			return new cls(voiceList);
		}
        
        /**
         * Converts a ByteArray containing raw fixed point audio data into a Wave file.
         * Works by generating a WAV header, and then copying the raw data after.
         * 
         * @param wavData the destination ByteArray in which to create the Wave file.
         * @param rawDataBytes the source ByteArray containing raw fixed point audio data
         * @param sampleRate the sampling rate of the raw audio data
         * @param numChannels the number of interleaved channels of audio data
         * @param bitDepth the bit depth of the audio data
         */
        public static function writeBytesToWavFile(wavData:ByteArray, rawDataBytes:ByteArray, sampleRate:uint, numChannels:uint, bitDepth:uint):void
        {
        	// Round data size to word if needed
        	var dataSize:uint = rawDataBytes.length;
        	if ((dataSize % 2) == 1) {
            	dataSize += 1; 
            	rawDataBytes.position = rawDataBytes.length;
            	rawDataBytes.writeByte(0);
            }
            
            // Write header
            writeHeader(wavData, dataSize, sampleRate, numChannels, bitDepth);
            
            // Write data
            wavData.writeBytes(rawDataBytes);
            
        }
        
        /**
         * Writes just a WAV header to a destination ByteArray
         * 
         * @param wavData the destination ByteArray in which to write the wav file header
         * @param dataSize the number of bytes of audio data (must be an even number of bytes, per WAV spec)
         * @param sampleRate the sampling rate of the raw audio data
         * @param numChannels the number of interleaved channels of audio data
         * @param bitDepth the bit depth of the audio data
         */  
        static private function writeHeader(wavData:ByteArray, dataSize:uint, sampleRate:uint, numChannels:uint, bitDepth:uint):void
        {
			wavData.endian = Endian.LITTLE_ENDIAN;
            
            wavData.writeUTFBytes(RIFF_GROUP_ID);
			wavData.writeUnsignedInt(HEADER_OFFSET + dataSize);
            
            wavData.writeUTFBytes(WAVE_TYPE);

            wavData.writeUTFBytes(FORMAT_CHUNK);
            //sub chunk size (of PCM)
			wavData.writeUnsignedInt(SUBCHUNK_SIZE_PCM);

            //format (1 for PCM)
			wavData.writeShort(UNCOMPRESSED_FORMAT);
            
            //number of channels (mono)
			wavData.writeShort(numChannels);

            //sample rate
			wavData.writeUnsignedInt(sampleRate);

            // Byte Rate
			wavData.writeUnsignedInt(sampleRate * numChannels * bitDepth / BYTE_LENGTH);

			wavData.writeShort(numChannels * bitDepth / BYTE_LENGTH);

            // bits per sample
			wavData.writeShort(bitDepth);
                        
            wavData.writeUTFBytes(DATA_CHUNK);
            
            //sub chunk size
			wavData.writeUnsignedInt(dataSize);
        }
    }
}