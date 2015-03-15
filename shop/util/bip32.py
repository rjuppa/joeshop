#!/usr/bin/python
import os
import struct
import hmac
import hashlib
import binascii

import ecdsa
from ecdsa.util import string_to_number, number_to_string
from ecdsa.curves import SECP256k1
from ecdsa.ellipticcurve import Point, INFINITY

class Node(object):
    def __init__(self):
        self.depth = 0
        self.child_num = 0
        self.chain_code = ''
        self.fingerprint = ''
        self.public_key = ''

    def CopyFrom(self, n2):
        self.depth = n2.depth
        self.child_num = n2.child_num
        self.chain_code = n2.chain_code
        self.fingerprint = n2.fingerprint
        self.public_key = n2.public_key

    @classmethod
    def serialize(cls, node, version=0x0488B21E):
        s = ''
        s += struct.pack('>I', version)
        s += struct.pack('>B', node.depth)
        s += struct.pack('>I', node.fingerprint)
        s += struct.pack('>I', node.child_num)
        s += node.chain_code
        if node.private_key:
            s += '\x00' + node.private_key
        else :
            s += node.public_key
        s += Hash(s)[:4]
        return b58encode(s)

    @classmethod
    def deserialize(cls, xpub):
        if xpub[0:4] not in ('xpub', 'tpub'):
            raise Exception("Unknown type of xpub")

        if len(xpub) < 100 and len(xpub) > 112:
            raise Exception("Invalid length of xpub")

        node = Node()
        data = b58decode(xpub, None).encode('hex')

        if data[90:92] not in ('02', '03'):
            raise Exception("Contain invalid public key")

        checksum = hashlib.sha256(hashlib.sha256(binascii.unhexlify(data[:156])).digest()).hexdigest()[:8]
        if checksum != data[156:]:
            raise Exception("Checksum doesn't match")

        # version 0488ade4
        # depth 00
        # fingerprint 00000000
        # child_num 00000000
        # chaincode 873dff81c02f525623fd1fe5167eac3a55a049de3d314bb42ee227ffed37d508
        # privkey   00e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35
        # checksum e77e9d71

        node.depth = int(data[8:10], 16)
        node.fingerprint = int(data[10:18], 16)
        node.child_num = int(data[18:26], 16)
        node.chain_code = data[26:90].decode('hex')
        node.public_key = data[90:156].decode('hex')

        return node

PRIME_DERIVATION_FLAG = 0x80000000

__b58chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
__b58base = len(__b58chars)

def b58encode(v):
    """ encode v, which is a string of bytes, to base58."""

    long_value = 0L
    for (i, c) in enumerate(v[::-1]):
        long_value += (256 ** i) * ord(c)

    result = ''
    while long_value >= __b58base:
        div, mod = divmod(long_value, __b58base)
        result = __b58chars[mod] + result
        long_value = div
    result = __b58chars[long_value] + result

    # Bitcoin does a little leading-zero-compression:
    # leading 0-bytes in the input become leading-1s
    nPad = 0
    for c in v:
        if c == '\0':
            nPad += 1
        else:
            break

    return (__b58chars[0] * nPad) + result

def b58decode(v, length):
    """ decode v into a string of len bytes."""
    long_value = 0L
    for (i, c) in enumerate(v[::-1]):
        long_value += __b58chars.find(c) * (__b58base ** i)

    result = ''
    while long_value >= 256:
        div, mod = divmod(long_value, 256)
        result = chr(mod) + result
        long_value = div
    result = chr(long_value) + result

    nPad = 0
    for c in v:
        if c == __b58chars[0]:
            nPad += 1
        else:
            break

    result = chr(0) * nPad + result
    if length is not None and len(result) != length:
        return None

    return result

Hash = lambda x: hashlib.sha256(hashlib.sha256(x).digest()).digest()

def hash_160(public_key):
    md = hashlib.new('ripemd160')
    md.update(hashlib.sha256(public_key).digest())
    return md.digest()

def hash_160_to_bc_address(h160, address_type):
    vh160 = chr(address_type) + h160
    h = Hash(vh160)
    addr = vh160 + h[0:4]
    return b58encode(addr)

def compress_pubkey(public_key):
    if public_key[0] == '\x04':
        return chr((ord(public_key[64]) & 1) + 2) + public_key[1:33]
    raise Exception("Pubkey is already compressed")

def public_key_to_bc_address(public_key, address_type, compress=True):
    if public_key[0] == '\x04' and compress:
        public_key = compress_pubkey(public_key)

    h160 = hash_160(public_key)
    return hash_160_to_bc_address(h160, address_type)

def point_to_pubkey(point):
    order = SECP256k1.order
    x_str = number_to_string(point.x(), order)
    y_str = number_to_string(point.y(), order)
    vk = x_str + y_str
    return chr((ord(vk[63]) & 1) + 2) + vk[0:32]  # To compressed key

def sec_to_public_pair(pubkey):
    """Convert a public key in sec binary format to a public pair."""
    x = string_to_number(pubkey[1:33])
    sec0 = pubkey[:1]
    if sec0 not in (b'\2', b'\3'):
        raise Exception("Compressed pubkey expected")

    def public_pair_for_x(generator, x, is_even):
        curve = generator.curve()
        p = curve.p()
        alpha = (pow(x, 3, p) + curve.a() * x + curve.b()) % p
        beta = ecdsa.numbertheory.square_root_mod_prime(alpha, p)
        if is_even == bool(beta & 1):
            return (x, p - beta)
        return (x, beta)

    return public_pair_for_x(ecdsa.ecdsa.generator_secp256k1, x, is_even=(sec0 == b'\2'))

def is_prime(n):
    return (bool)(n & PRIME_DERIVATION_FLAG)

def fingerprint(pubkey):
    return string_to_number(hash_160(pubkey)[:4])

def get_address(public_node, address_type):
    return public_key_to_bc_address(public_node.public_key, address_type)

def public_ckd(public_node, n):
    if not isinstance(n, list):
        raise Exception('Parameter must be a list')

    node = Node()
    node.CopyFrom(public_node)

    for i in n:
        node.CopyFrom(get_subnode(node, i))

    return node

def get_subnode(node, i):
    # Public Child key derivation (CKD) algorithm of BIP32
    i_as_bytes = struct.pack(">L", i)

    if is_prime(i):
        raise Exception("Prime derivation not supported")

    # Public derivation
    data = node.public_key + i_as_bytes

    I64 = hmac.HMAC(key=node.chain_code, msg=data, digestmod=hashlib.sha512).digest()
    I_left_as_exponent = string_to_number(I64[:32])

    node_out = Node()
    node_out.depth = node.depth + 1
    node_out.child_num = i
    node_out.chain_code = I64[32:]
    node_out.fingerprint = fingerprint(node.public_key)

    # BIP32 magic converts old public key to new public point
    x, y = sec_to_public_pair(node.public_key)
    point = I_left_as_exponent * SECP256k1.generator + \
            Point(SECP256k1.curve, x, y, SECP256k1.order)

    if point == INFINITY:
        raise Exception("Point cannot be INFINITY")

    # Convert public point to compressed public key
    node_out.public_key = point_to_pubkey(point)

    return node_out

def get_address_for_account(xpub, i, address_type=0):
    # Returns i-th address of BIP44 account defined by its xpub
    node = Node.deserialize(xpub)
    n2 = public_ckd(node, [0, i])
    return get_address(n2, address_type)

