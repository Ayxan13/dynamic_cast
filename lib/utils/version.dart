class Version {
  final int major;
  final int minor;
  final int patch;

  const Version(int major, int minor, int patch)
      : major = major,
        minor = minor,
        patch = patch;

  String toString() {
    return "$major.$minor.$patch";
  }

  bool operator <(Version other) {
    if (major != other.major) return major < other.major;
    if (minor != other.minor) return minor < other.minor;
    return patch < other.patch;
  }

  bool operator ==(Object other) {
    if (other is! Version) return false;
    return major == other.major && minor == other.minor && patch == other.patch;
  }

  @override
  int get hashCode {
    return (major + minor * 1249) ^ (patch * 7717);
  }
}
