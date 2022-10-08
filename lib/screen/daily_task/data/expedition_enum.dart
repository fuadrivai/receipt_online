// ignore_for_file: constant_identifier_names

class ValidExpedition {
  static const String LEX = "LEX";
  static const String ANTARAJA = "ANTARAJA";
  static const String JNE = "JNE";
  static const String COOR = "COOR";
  static const String NINJA = "NINJA";
  static const String SHOPEE = "SHOPEE";
  static const String SAMEDAY = "SAMEDAY";
  static const String JX = "JX";
  static const String INSTANT = "INSTANT";
  static const String SH_INSTANT = "SH_INSTANT";

  static bool lex(String data) {
    if (data.length < 15) {
      return false;
    } else if (data.contains("LXAD") || data.contains("lxad")) {
      return true;
    } else if (data.contains("JNAP") || data.contains("jnap")) {
      return true;
    } else if (data.contains("NLIDAP") || data.contains("nlidap")) {
      return true;
    } else {
      return false;
    }
  }

  static bool shopee(String data) {
    if (data.length < 17) {
      return false;
    } else if (data.contains("SPXID")) {
      return true;
    } else {
      return false;
    }
  }

  static bool shInstant(data) {
    if (data.length < 19) {
      return false;
    } else {
      return false;
    }
  }

  static bool validReceipt({required String platform, required String data}) {
    bool valid = true;
    switch (platform) {
      case ValidExpedition.LEX:
        valid = ValidExpedition.lex(data);
        break;
      case ValidExpedition.SHOPEE:
        valid = ValidExpedition.shopee(data);
        break;
      case ValidExpedition.SH_INSTANT:
        valid = ValidExpedition.shInstant(data);
        break;
      case ValidExpedition.ANTARAJA:
        valid = true;
        break;
      case ValidExpedition.COOR:
        valid = true;
        break;
      case ValidExpedition.INSTANT:
        valid = true;
        break;
      case ValidExpedition.JNE:
        valid = true;
        break;
      case ValidExpedition.JX:
        valid = true;
        break;
      case ValidExpedition.NINJA:
        valid = true;
        break;
      case ValidExpedition.SAMEDAY:
        valid = true;
        break;
      default:
        valid = true;
        break;
    }
    return valid;
  }
}
