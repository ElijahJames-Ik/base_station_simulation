class ChannelData {
  // has three types audio, video and text
  // audio has a minimum size of 1mb and max of 3 mb
  // text has a minimum of 0.5mb  and a max of 1mb
  // video has a minimum of 100mb to max of 300mb

   bool state;
   int megabyte;
  
  ChannelData(
      {required this.state,
      required this.megabyte,
      });
}
