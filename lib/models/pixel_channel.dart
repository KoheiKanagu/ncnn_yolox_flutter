enum PixelChannel {
  c1,
  c2,
  c3,
  c4,
}

extension PixelChannelExtension on PixelChannel {
  int get channelNum {
    switch (this) {
      case PixelChannel.c1:
        return 1;
      case PixelChannel.c2:
        return 2;
      case PixelChannel.c3:
        return 3;
      case PixelChannel.c4:
        return 4;
    }
  }
}
