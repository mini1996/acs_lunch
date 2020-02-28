import 'UuidUtil.dart';
import 'package:convert/convert.dart' as convert;

class GetUUID {
  static const NAMESPACE_DNS = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
  static const NAMESPACE_URL = '6ba7b811-9dad-11d1-80b4-00c04fd430c8';
  static const NAMESPACE_OID = '6ba7b812-9dad-11d1-80b4-00c04fd430c8';
  static const NAMESPACE_X500 = '6ba7b814-9dad-11d1-80b4-00c04fd430c8';
  static const NAMESPACE_NIL = '00000000-0000-0000-0000-000000000000';

  var _seedBytes, _nodeId, _clockSeq, _lastMSecs = 0, _lastNSecs = 0;
  Function _globalRNG;
  List<String> _byteToHex;
  Map<String, int> _hexToByte;
  GetUUID({Map<String, dynamic> options}) {
    options = (options != null) ? options : new Map();
    _byteToHex = new List<String>(256);
    _hexToByte = new Map<String, int>();

    // Easy number <-> hex conversion
    for (var i = 0; i < 256; i++) {
      var hex = new List<int>();
      hex.add(i);
      _byteToHex[i] = convert.hex.encode(hex);
      _hexToByte[_byteToHex[i]] = i;
    }

    // Sets initial seedBytes, node, and clock seq based on mathRNG.
    var v1PositionalArgs = (options['v1rngPositionalArgs'] != null)
        ? options['v1rngPositionalArgs']
        : [];
    var v1NamedArgs = (options['v1rngNamedArgs'] != null)
        ? options['v1rngNamedArgs'] as Map<Symbol, dynamic>
        : const <Symbol, dynamic>{};
    _seedBytes = (options['v1rng'] != null)
        ? Function.apply(options['v1rng'], v1PositionalArgs, v1NamedArgs)
        : UuidUtil.mathRNG();

    // Set the globalRNG function to mathRNG with the option to set an alternative globally
    var gPositionalArgs = (options['grngPositionalArgs'] != null)
        ? options['grngPositionalArgs']
        : [];
    var gNamedArgs = (options['grngNamedArgs'] != null)
        ? options['grngNamedArgs'] as Map<Symbol, dynamic>
        : const <Symbol, dynamic>{};
    _globalRNG = () {
      return (options['grng'] != null)
          ? Function.apply(options['grng'], gPositionalArgs, gNamedArgs)
          : UuidUtil.mathRNG();
    };

    // Per 4.5, create a 48-bit node id (47 random bits + multicast bit = 1)
    _nodeId = [
      _seedBytes[0] | 0x01,
      _seedBytes[1],
      _seedBytes[2],
      _seedBytes[3],
      _seedBytes[4],
      _seedBytes[5]
    ];

    // Per 4.2.2, randomize (14 bit) clockseq
    _clockSeq = (_seedBytes[6] << 8 | _seedBytes[7]) & 0x3ffff;
  }

  String v1({Map<String, dynamic> options}) {
    var i = 0;
    var buf = new List<int>(16);
    options = (options != null) ? options : new Map();

    var clockSeq =
        (options['clockSeq'] != null) ? options['clockSeq'] : _clockSeq;

    // UUID timestamps are 100 nano-second units since the Gregorian epoch,
    // (1582-10-15 00:00). Time is handled internally as 'msecs' (integer
    // milliseconds) and 'nsecs' (100-nanoseconds offset from msecs) since unix
    // epoch, 1970-01-01 00:00.
    var mSecs = (options['mSecs'] != null)
        ? options['mSecs']
        : (new DateTime.now()).millisecondsSinceEpoch;

    // Per 4.2.1.2, use count of uuid's generated during the current clock
    // cycle to simulate higher resolution clock
    var nSecs = (options['nSecs'] != null) ? options['nSecs'] : _lastNSecs + 1;

    // Time since last uuid creation (in msecs)
    var dt = (mSecs - _lastMSecs) + (nSecs - _lastNSecs) / 10000;

    // Per 4.2.1.2, Bump clockseq on clock regression
    if (dt < 0 && options['clockSeq'] == null) {
      clockSeq = clockSeq + 1 & 0x3fff;
    }

    // Reset nsecs if clock regresses (new clockseq) or we've moved onto a new
    // time interval
    if ((dt < 0 || mSecs > _lastMSecs) && options['nSecs'] == null) {
      nSecs = 0;
    }

    // Per 4.2.1.2 Throw error if too many uuids are requested
    if (nSecs >= 10000) {
      throw new Exception('uuid.v1(): Can\'t create more than 10M uuids/sec');
    }

    _lastMSecs = mSecs;
    _lastNSecs = nSecs;
    _clockSeq = clockSeq;

    // Per 4.1.4 - Convert from unix epoch to Gregorian epoch
    mSecs += 12219292800000;

    // time Low
    var tl = ((mSecs & 0xfffffff) * 10000 + nSecs) % 0x100000000;
    buf[i++] = tl >> 24 & 0xff;
    buf[i++] = tl >> 16 & 0xff;
    buf[i++] = tl >> 8 & 0xff;
    buf[i++] = tl & 0xff;

    // time mid
    var tmh = (mSecs / 0x100000000 * 10000).floor() & 0xfffffff;
    buf[i++] = tmh >> 8 & 0xff;
    buf[i++] = tmh & 0xff;

    // time high and version
    buf[i++] = tmh >> 24 & 0xf | 0x10; // include version
    buf[i++] = tmh >> 16 & 0xff;

    // clockSeq high and reserved (Per 4.2.2 - include variant)
    buf[i++] = clockSeq >> 8 | 0x80;

    // clockSeq low
    buf[i++] = clockSeq & 0xff;

    // node
    var node = (options['node'] != null) ? options['node'] : _nodeId;
    for (var n = 0; n < 6; n++) {
      buf[i + n] = node[n];
    }

    return unparse(buf);
  }

  String unparse(List<int> buffer, {int offset = 0}) {
    var i = offset;
    return '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}';
  }
}
