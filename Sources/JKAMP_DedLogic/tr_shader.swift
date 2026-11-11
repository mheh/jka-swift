import Foundation
import JKAMP
import JKAShared
import JKAMP_Ded

/// Source: oracle/codemp/renderer/tr_shader.cpp:16
// Raven wrote: const unsigned char g_strGlowVShaderARB[]
// Raven's string literal, as the character codes in hex after the line splices, with the NUL.
let g_strGlowVShaderARB: [UInt8] = [
    0x21, 0x21, 0x41, 0x52, 0x42, 0x76, 0x70, 0x31, 0x2E, 0x30, 0x09, 0x09, 0x23, 0x20, 0x49, 0x6E,
    0x70, 0x75, 0x74, 0x2E, 0x0A, 0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09, 0x69, 0x50, 0x6F,
    0x73, 0x09, 0x09, 0x3D, 0x20, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x2E, 0x70, 0x6F, 0x73, 0x69,
    0x74, 0x69, 0x6F, 0x6E, 0x3B, 0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09, 0x69, 0x43, 0x6F,
    0x6C, 0x6F, 0x72, 0x09, 0x09, 0x3D, 0x20, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x2E, 0x63, 0x6F,
    0x6C, 0x6F, 0x72, 0x3B, 0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09, 0x69, 0x54, 0x65, 0x78,
    0x30, 0x09, 0x09, 0x3D, 0x20, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x2E, 0x74, 0x65, 0x78, 0x63,
    0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x30, 0x5D, 0x3B, 0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09,
    0x69, 0x54, 0x65, 0x78, 0x31, 0x09, 0x09, 0x3D, 0x20, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x2E,
    0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x31, 0x5D, 0x3B, 0x09, 0x41, 0x54, 0x54,
    0x52, 0x49, 0x42, 0x09, 0x69, 0x54, 0x65, 0x78, 0x32, 0x09, 0x09, 0x3D, 0x20, 0x76, 0x65, 0x72,
    0x74, 0x65, 0x78, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x32, 0x5D, 0x3B,
    0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09, 0x69, 0x54, 0x65, 0x78, 0x33, 0x09, 0x09, 0x3D,
    0x20, 0x76, 0x65, 0x72, 0x74, 0x65, 0x78, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64,
    0x5B, 0x33, 0x5D, 0x3B, 0x09, 0x09, 0x23, 0x20, 0x4F, 0x75, 0x74, 0x70, 0x75, 0x74, 0x2E, 0x0A,
    0x09, 0x4F, 0x55, 0x54, 0x50, 0x55, 0x54, 0x09, 0x6F, 0x50, 0x6F, 0x73, 0x09, 0x09, 0x3D, 0x20,
    0x72, 0x65, 0x73, 0x75, 0x6C, 0x74, 0x2E, 0x70, 0x6F, 0x73, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x3B,
    0x09, 0x4F, 0x55, 0x54, 0x50, 0x55, 0x54, 0x09, 0x6F, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x09, 0x09,
    0x3D, 0x20, 0x72, 0x65, 0x73, 0x75, 0x6C, 0x74, 0x2E, 0x63, 0x6F, 0x6C, 0x6F, 0x72, 0x3B, 0x09,
    0x4F, 0x55, 0x54, 0x50, 0x55, 0x54, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x30, 0x09, 0x09, 0x3D, 0x20,
    0x72, 0x65, 0x73, 0x75, 0x6C, 0x74, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B,
    0x30, 0x5D, 0x3B, 0x09, 0x4F, 0x55, 0x54, 0x50, 0x55, 0x54, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x31,
    0x09, 0x09, 0x3D, 0x20, 0x72, 0x65, 0x73, 0x75, 0x6C, 0x74, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F,
    0x6F, 0x72, 0x64, 0x5B, 0x31, 0x5D, 0x3B, 0x09, 0x4F, 0x55, 0x54, 0x50, 0x55, 0x54, 0x09, 0x6F,
    0x54, 0x65, 0x78, 0x32, 0x09, 0x09, 0x3D, 0x20, 0x72, 0x65, 0x73, 0x75, 0x6C, 0x74, 0x2E, 0x74,
    0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x32, 0x5D, 0x3B, 0x09, 0x4F, 0x55, 0x54, 0x50,
    0x55, 0x54, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x33, 0x09, 0x09, 0x3D, 0x20, 0x72, 0x65, 0x73, 0x75,
    0x6C, 0x74, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x33, 0x5D, 0x3B, 0x09,
    0x09, 0x23, 0x20, 0x43, 0x6F, 0x6E, 0x73, 0x74, 0x61, 0x6E, 0x74, 0x73, 0x2E, 0x0A, 0x09, 0x50,
    0x41, 0x52, 0x41, 0x4D, 0x09, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x56, 0x69, 0x65, 0x77, 0x50, 0x72,
    0x6F, 0x6A, 0x5B, 0x34, 0x5D, 0x3D, 0x20, 0x7B, 0x20, 0x73, 0x74, 0x61, 0x74, 0x65, 0x2E, 0x6D,
    0x61, 0x74, 0x72, 0x69, 0x78, 0x2E, 0x6D, 0x76, 0x70, 0x20, 0x7D, 0x3B, 0x09, 0x50, 0x41, 0x52,
    0x41, 0x4D, 0x09, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x30, 0x09,
    0x3D, 0x20, 0x70, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x2E, 0x65, 0x6E, 0x76, 0x5B, 0x30, 0x5D,
    0x3B, 0x09, 0x50, 0x41, 0x52, 0x41, 0x4D, 0x09, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66,
    0x73, 0x65, 0x74, 0x31, 0x09, 0x3D, 0x20, 0x70, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x2E, 0x65,
    0x6E, 0x76, 0x5B, 0x31, 0x5D, 0x3B, 0x09, 0x50, 0x41, 0x52, 0x41, 0x4D, 0x09, 0x54, 0x65, 0x78,
    0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x32, 0x09, 0x3D, 0x20, 0x70, 0x72, 0x6F, 0x67,
    0x72, 0x61, 0x6D, 0x2E, 0x65, 0x6E, 0x76, 0x5B, 0x32, 0x5D, 0x3B, 0x09, 0x50, 0x41, 0x52, 0x41,
    0x4D, 0x09, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x33, 0x09, 0x3D,
    0x20, 0x70, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x2E, 0x65, 0x6E, 0x76, 0x5B, 0x33, 0x5D, 0x3B,
    0x09, 0x09, 0x23, 0x20, 0x4D, 0x61, 0x69, 0x6E, 0x2E, 0x0A, 0x09, 0x44, 0x50, 0x34, 0x09, 0x09,
    0x6F, 0x50, 0x6F, 0x73, 0x2E, 0x78, 0x2C, 0x20, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x56, 0x69, 0x65,
    0x77, 0x50, 0x72, 0x6F, 0x6A, 0x5B, 0x30, 0x5D, 0x2C, 0x20, 0x69, 0x50, 0x6F, 0x73, 0x3B, 0x09,
    0x44, 0x50, 0x34, 0x09, 0x09, 0x6F, 0x50, 0x6F, 0x73, 0x2E, 0x79, 0x2C, 0x20, 0x4D, 0x6F, 0x64,
    0x65, 0x6C, 0x56, 0x69, 0x65, 0x77, 0x50, 0x72, 0x6F, 0x6A, 0x5B, 0x31, 0x5D, 0x2C, 0x20, 0x69,
    0x50, 0x6F, 0x73, 0x3B, 0x09, 0x44, 0x50, 0x34, 0x09, 0x09, 0x6F, 0x50, 0x6F, 0x73, 0x2E, 0x7A,
    0x2C, 0x20, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x56, 0x69, 0x65, 0x77, 0x50, 0x72, 0x6F, 0x6A, 0x5B,
    0x32, 0x5D, 0x2C, 0x20, 0x69, 0x50, 0x6F, 0x73, 0x3B, 0x09, 0x44, 0x50, 0x34, 0x09, 0x09, 0x6F,
    0x50, 0x6F, 0x73, 0x2E, 0x77, 0x2C, 0x20, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x56, 0x69, 0x65, 0x77,
    0x50, 0x72, 0x6F, 0x6A, 0x5B, 0x33, 0x5D, 0x2C, 0x20, 0x69, 0x50, 0x6F, 0x73, 0x3B, 0x09, 0x4D,
    0x4F, 0x56, 0x09, 0x09, 0x6F, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x2C, 0x20, 0x69, 0x43, 0x6F, 0x6C,
    0x6F, 0x72, 0x3B, 0x09, 0x23, 0x20, 0x4E, 0x6F, 0x74, 0x69, 0x63, 0x65, 0x20, 0x74, 0x68, 0x65,
    0x20, 0x6F, 0x70, 0x74, 0x69, 0x6D, 0x69, 0x7A, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x6F, 0x66,
    0x20, 0x75, 0x73, 0x69, 0x6E, 0x67, 0x20, 0x6F, 0x6E, 0x65, 0x20, 0x74, 0x65, 0x78, 0x74, 0x75,
    0x72, 0x65, 0x20, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x20, 0x69, 0x6E, 0x73, 0x74, 0x65, 0x61, 0x64,
    0x20, 0x6F, 0x66, 0x20, 0x61, 0x6C, 0x6C, 0x20, 0x66, 0x6F, 0x75, 0x72, 0x2E, 0x0A, 0x09, 0x41,
    0x44, 0x44, 0x09, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x30, 0x2C, 0x20, 0x69, 0x54, 0x65, 0x78, 0x30,
    0x2C, 0x20, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x30, 0x3B, 0x09,
    0x41, 0x44, 0x44, 0x09, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x31, 0x2C, 0x20, 0x69, 0x54, 0x65, 0x78,
    0x30, 0x2C, 0x20, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x31, 0x3B,
    0x09, 0x41, 0x44, 0x44, 0x09, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x32, 0x2C, 0x20, 0x69, 0x54, 0x65,
    0x78, 0x30, 0x2C, 0x20, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74, 0x32,
    0x3B, 0x09, 0x41, 0x44, 0x44, 0x09, 0x09, 0x6F, 0x54, 0x65, 0x78, 0x33, 0x2C, 0x20, 0x69, 0x54,
    0x65, 0x78, 0x30, 0x2C, 0x20, 0x54, 0x65, 0x78, 0x65, 0x6C, 0x4F, 0x66, 0x66, 0x73, 0x65, 0x74,
    0x33, 0x3B, 0x09, 0x09, 0x45, 0x4E, 0x44, 0x00,
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:60
// Raven wrote: const unsigned char g_strGlowPShaderARB[]
// Raven's string literal, as the character codes in hex after the line splices, with the NUL.
let g_strGlowPShaderARB: [UInt8] = [
    0x21, 0x21, 0x41, 0x52, 0x42, 0x66, 0x70, 0x31, 0x2E, 0x30, 0x09, 0x09, 0x23, 0x20, 0x49, 0x6E,
    0x70, 0x75, 0x74, 0x2E, 0x0A, 0x09, 0x41, 0x54, 0x54, 0x52, 0x49, 0x42, 0x09, 0x69, 0x43, 0x6F,
    0x6C, 0x6F, 0x72, 0x09, 0x3D, 0x20, 0x66, 0x72, 0x61, 0x67, 0x6D, 0x65, 0x6E, 0x74, 0x2E, 0x63,
    0x6F, 0x6C, 0x6F, 0x72, 0x2E, 0x70, 0x72, 0x69, 0x6D, 0x61, 0x72, 0x79, 0x3B, 0x09, 0x09, 0x23,
    0x20, 0x4F, 0x75, 0x74, 0x70, 0x75, 0x74, 0x2E, 0x0A, 0x09, 0x4F, 0x55, 0x54, 0x50, 0x55, 0x54,
    0x09, 0x6F, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x09, 0x3D, 0x20, 0x72, 0x65, 0x73, 0x75, 0x6C, 0x74,
    0x2E, 0x63, 0x6F, 0x6C, 0x6F, 0x72, 0x3B, 0x09, 0x09, 0x23, 0x20, 0x43, 0x6F, 0x6E, 0x73, 0x74,
    0x61, 0x6E, 0x74, 0x73, 0x2E, 0x0A, 0x09, 0x50, 0x41, 0x52, 0x41, 0x4D, 0x09, 0x57, 0x65, 0x69,
    0x67, 0x68, 0x74, 0x09, 0x3D, 0x20, 0x70, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x2E, 0x65, 0x6E,
    0x76, 0x5B, 0x30, 0x5D, 0x3B, 0x09, 0x54, 0x45, 0x4D, 0x50, 0x09, 0x74, 0x30, 0x3B, 0x09, 0x54,
    0x45, 0x4D, 0x50, 0x09, 0x74, 0x31, 0x3B, 0x09, 0x54, 0x45, 0x4D, 0x50, 0x09, 0x74, 0x32, 0x3B,
    0x09, 0x54, 0x45, 0x4D, 0x50, 0x09, 0x74, 0x33, 0x3B, 0x09, 0x54, 0x45, 0x4D, 0x50, 0x09, 0x72,
    0x30, 0x3B, 0x09, 0x09, 0x23, 0x20, 0x4D, 0x61, 0x69, 0x6E, 0x2E, 0x0A, 0x09, 0x54, 0x45, 0x58,
    0x09, 0x09, 0x74, 0x30, 0x2C, 0x20, 0x66, 0x72, 0x61, 0x67, 0x6D, 0x65, 0x6E, 0x74, 0x2E, 0x74,
    0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x30, 0x5D, 0x2C, 0x20, 0x74, 0x65, 0x78, 0x74,
    0x75, 0x72, 0x65, 0x5B, 0x30, 0x5D, 0x2C, 0x20, 0x52, 0x45, 0x43, 0x54, 0x3B, 0x09, 0x54, 0x45,
    0x58, 0x09, 0x09, 0x74, 0x31, 0x2C, 0x20, 0x66, 0x72, 0x61, 0x67, 0x6D, 0x65, 0x6E, 0x74, 0x2E,
    0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x31, 0x5D, 0x2C, 0x20, 0x74, 0x65, 0x78,
    0x74, 0x75, 0x72, 0x65, 0x5B, 0x31, 0x5D, 0x2C, 0x20, 0x52, 0x45, 0x43, 0x54, 0x3B, 0x09, 0x54,
    0x45, 0x58, 0x09, 0x09, 0x74, 0x32, 0x2C, 0x20, 0x66, 0x72, 0x61, 0x67, 0x6D, 0x65, 0x6E, 0x74,
    0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x32, 0x5D, 0x2C, 0x20, 0x74, 0x65,
    0x78, 0x74, 0x75, 0x72, 0x65, 0x5B, 0x32, 0x5D, 0x2C, 0x20, 0x52, 0x45, 0x43, 0x54, 0x3B, 0x09,
    0x54, 0x45, 0x58, 0x09, 0x09, 0x74, 0x33, 0x2C, 0x20, 0x66, 0x72, 0x61, 0x67, 0x6D, 0x65, 0x6E,
    0x74, 0x2E, 0x74, 0x65, 0x78, 0x63, 0x6F, 0x6F, 0x72, 0x64, 0x5B, 0x33, 0x5D, 0x2C, 0x20, 0x74,
    0x65, 0x78, 0x74, 0x75, 0x72, 0x65, 0x5B, 0x33, 0x5D, 0x2C, 0x20, 0x52, 0x45, 0x43, 0x54, 0x3B,
    0x09, 0x20, 0x20, 0x20, 0x20, 0x4D, 0x55, 0x4C, 0x09, 0x09, 0x72, 0x30, 0x2C, 0x20, 0x74, 0x30,
    0x2C, 0x20, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x3B, 0x09, 0x4D, 0x41, 0x44, 0x09, 0x09, 0x72,
    0x30, 0x2C, 0x20, 0x74, 0x31, 0x2C, 0x20, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2C, 0x20, 0x72,
    0x30, 0x3B, 0x09, 0x4D, 0x41, 0x44, 0x09, 0x09, 0x72, 0x30, 0x2C, 0x20, 0x74, 0x32, 0x2C, 0x20,
    0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2C, 0x20, 0x72, 0x30, 0x3B, 0x09, 0x4D, 0x41, 0x44, 0x09,
    0x09, 0x72, 0x30, 0x2C, 0x20, 0x74, 0x33, 0x2C, 0x20, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2C,
    0x20, 0x72, 0x30, 0x3B, 0x09, 0x09, 0x4D, 0x4F, 0x56, 0x09, 0x09, 0x6F, 0x43, 0x6F, 0x6C, 0x6F,
    0x72, 0x2C, 0x20, 0x72, 0x30, 0x3B, 0x09, 0x09, 0x45, 0x4E, 0x44, 0x00,
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:96
// Raven wrote: static char *s_shaderText
let s_shaderText: String = ""

/// Source: oracle/codemp/renderer/tr_shader.cpp:100
var stages: Slots<ShaderStage> { world.storage.stages }

/// Source: oracle/codemp/renderer/tr_shader.cpp:101
var shader: Shader { world.storage.shader }

/// Source: oracle/codemp/renderer/tr_shader.cpp:102
var texMods: Slots<TexModInfo> { world.storage.texMods }

/// Source: oracle/codemp/renderer/tr_shader.cpp:103
var deferLoad: Bool {
    get { world.variables.deferLoad }
    set { world.variables.deferLoad = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:105
private let FILE_HASH_SIZE = 1024 as Int32

/// Source: oracle/codemp/renderer/tr_shader.cpp:106
private var hashTable: Slots<Shader?> { world.storage.tr_shader_hashTable }

/// Source: oracle/codemp/renderer/tr_shader.cpp:108
let MAX_SHADERTEXT_HASH = 2048 as Int32

/// Source: oracle/codemp/renderer/tr_shader.cpp:109
/// Raven's table, a hand property of `EngineWorld`, by the HAND_VARS ruling.
var shaderTextHashTable: [[TextCursor]] {
    get { world.shaderTextHashTable }
    set { world.shaderTextHashTable = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:125
/// Raven's data table, a hand property of `EngineWorld`.
var lightmapsNone: [Int32] {
    get { world.lightmapsNone }
    set { world.lightmapsNone = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:133
/// Raven's data table, a hand property of `EngineWorld`.
var lightmaps2d: [Int32] {
    get { world.lightmaps2d }
    set { world.lightmaps2d = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:141
// Raven wrote: const int lightmapsVertex[MAXLIGHTMAPS]
let lightmapsVertex: [Int32] = [
    LIGHTMAP_BY_VERTEX,
    LIGHTMAP_BY_VERTEX,
    LIGHTMAP_BY_VERTEX,
    LIGHTMAP_BY_VERTEX,
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:149
// Raven wrote: const int lightmapsFullBright[MAXLIGHTMAPS]
let lightmapsFullBright: [Int32] = [
    LIGHTMAP_WHITEIMAGE,
    LIGHTMAP_WHITEIMAGE,
    LIGHTMAP_WHITEIMAGE,
    LIGHTMAP_WHITEIMAGE,
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:157
/// Raven's data table, a hand property of `EngineWorld`.
var stylesDefault: [JKAShared.byte] {
    get { world.stylesDefault }
    set { world.stylesDefault = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:1402
let MAX_IMAGE_ANIMATIONS = 32 as Int32

/// Source: oracle/codemp/renderer/tr_shader.cpp:2193
/// Raven's data table, a hand property of `EngineWorld`.
var materialNames: [String] {
    get { world.materialNames }
    set { world.materialNames = newValue }
}

// this table is also present in q3map

/// Source: oracle/codemp/renderer/tr_shader.cpp:2228
// AI: Raven keeps `infoParm_t infoParms[]` as C data. The table is a constant Array of the `InfoParm` rows of cm_shader.swift, whose `infoParm_t` has the same fields.
let infoParms: [InfoParm] = [
    // Game content Flags
    InfoParm(name: "nonsolid", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: 0), // special hack to clear solid flag
    InfoParm(name: "nonopaque", clearSolid: ~CONTENTS_OPAQUE, surfaceFlags: 0, contents: 0), // special hack to clear opaque flag
    InfoParm(name: "lava", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_LAVA), // very damaging
    InfoParm(name: "slime", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_SLIME), // mildly damaging
    InfoParm(name: "water", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_WATER),
    InfoParm(name: "fog", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_FOG), // carves surfaces entering
    InfoParm(name: "shotclip", clearSolid: ~CONTENTS_SOLID, surfaceFlags: 0, contents: CONTENTS_SHOTCLIP), // block shots, but not people
    InfoParm(name: "playerclip", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_PLAYERCLIP), // block only the player
    InfoParm(name: "monsterclip", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_MONSTERCLIP),
    InfoParm(name: "botclip", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_BOTCLIP), // for bots
    InfoParm(name: "trigger", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_TRIGGER),
    InfoParm(name: "nodrop", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_NODROP), // don't drop items or leave bodies (death fog, lava, etc)
    InfoParm(name: "terrain", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_TERRAIN), // use special terrain collsion
    InfoParm(name: "ladder", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_LADDER), // climb up in it like water
    InfoParm(name: "abseil", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_ABSEIL), // can abseil down this brush
    InfoParm(name: "outside", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_OUTSIDE), // volume is considered to be in the outside (i.e. not indoors)
    InfoParm(name: "inside", clearSolid: ~(CONTENTS_SOLID | CONTENTS_OPAQUE), surfaceFlags: 0, contents: CONTENTS_INSIDE), // volume is considered to be inside (i.e. indoors)

    InfoParm(name: "detail", clearSolid: -1, surfaceFlags: 0, contents: CONTENTS_DETAIL), // don't include in structural bsp
    // Raven wrote CONTENTS_TRANSLUCENT, the unsigned 0x80000000.
    InfoParm(name: "trans", clearSolid: -1, surfaceFlags: 0, contents: ~0x7fff_ffff), // surface has an alpha component

    /* Game surface flags */
    InfoParm(name: "sky", clearSolid: -1, surfaceFlags: SURF_SKY, contents: 0), // emit light from an environment map
    InfoParm(name: "slick", clearSolid: -1, surfaceFlags: SURF_SLICK, contents: 0),

    InfoParm(name: "nodamage", clearSolid: -1, surfaceFlags: SURF_NODAMAGE, contents: 0),
    InfoParm(name: "noimpact", clearSolid: -1, surfaceFlags: SURF_NOIMPACT, contents: 0), // don't make impact explosions or marks
    InfoParm(name: "nomarks", clearSolid: -1, surfaceFlags: SURF_NOMARKS, contents: 0), // don't make impact marks, but still explode
    InfoParm(name: "nodraw", clearSolid: -1, surfaceFlags: SURF_NODRAW, contents: 0), // don't generate a drawsurface (or a lightmap)
    InfoParm(name: "nosteps", clearSolid: -1, surfaceFlags: SURF_NOSTEPS, contents: 0),
    InfoParm(name: "nodlight", clearSolid: -1, surfaceFlags: SURF_NODLIGHT, contents: 0), // don't ever add dynamic lights
    InfoParm(name: "metalsteps", clearSolid: -1, surfaceFlags: SURF_METALSTEPS, contents: 0),
    InfoParm(name: "nomiscents", clearSolid: -1, surfaceFlags: SURF_NOMISCENTS, contents: 0), // No misc ents on this surface
    InfoParm(name: "forcefield", clearSolid: -1, surfaceFlags: SURF_FORCEFIELD, contents: 0),
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:111
func KillTheShaderHashTable() {
    // AI: Raven zeroes the pointer of each hash. The table holds one list of cursors per hash, and each list empties.
    shaderTextHashTable.fill([])
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:116
func ShaderHashTableExists() -> Bool {
    // AI: Raven tests the pointer of hash 0. The test reads whether the list of hash 0 holds a cursor.
    if !shaderTextHashTable[0].isEmpty {
        return true
    }
    return false
}

/**
```
===============
R_CreateExtendedName

  Creates a unique shader name taking into account lightstyles
===============
```
*/
//rwwRMG - added
/// Source: oracle/codemp/renderer/tr_shader.cpp:177
func R_CreateExtendedName(_ extendedName: inout JKAShared.CharBuf, _ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte]) {
    var i: Int32

    // Set the basename
    COM_StripExtension(name, &extendedName)

    // Add in lightmaps
    if lightmapIndex != nil {
        // AI: Raven compares the address of `lightmapIndex` with the four tables. The tests compare the values, by the ruling of the lightmap lists.
        if lightmapIndex! == lightmapsNone {
            strcat(&extendedName, "_nolightmap")
        } else if lightmapIndex! == lightmaps2d {
            strcat(&extendedName, "_2d")
        } else if lightmapIndex! == lightmapsVertex {
            strcat(&extendedName, "_vertex")
        } else if lightmapIndex! == lightmapsFullBright {
            strcat(&extendedName, "_fullbright")
        } else {
            i = 0
            while (i < 4) && (styles[i] != 255) {
                switch lightmapIndex![i] {
                case LIGHTMAP_NONE:
                    strcat(&extendedName, va("_style(%d,none)", styles[i]))
                case LIGHTMAP_2D:
                    strcat(&extendedName, va("_style(%d,2d)", styles[i]))
                case LIGHTMAP_BY_VERTEX:
                    strcat(&extendedName, va("_style(%d,vert)", styles[i]))
                case LIGHTMAP_WHITEIMAGE:
                    strcat(&extendedName, va("_style(%d,fb)", styles[i]))
                default:
                    strcat(&extendedName, va("_style(%d,%d)", styles[i], lightmapIndex![i]))
                }
                i += 1
            }
        }
    }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:234
private func ClearGlobalShader() {
    var i: Int32

    shader.clear()
    stages.zero()
    i = 0
    while i < MAX_SHADER_STAGES {
        // Raven's row `texMods[i]` of the two-dimensional table starts at record `i * TR_MAX_TEXMODS` of the flat storage.
        stages[i].bundle[0].texModsSlots = texMods.suffix(from: i * TR_MAX_TEXMODS)
        stages[i].mGLFogColorOverride = GLFOGOVERRIDE_NONE
        i += 1
    }

    shader.contentFlags = CONTENTS_SOLID | CONTENTS_OPAQUE
}

/**
```
================
return a hash value for the filename
================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:253
private func generateHashValue(_ fname: String, _ size: Int32) -> CLong {
    var i: Int32
    var hash: CLong
    var letter: CChar
    // Raven indexes his own `fname` parameter by byte, so the body reads a CharBuf of it.
    let fname = CharBuf(fname)

    hash = 0
    i = 0
    while fname[i] != 0 {
        let byte: UInt8 = fname[i]
        // Foundation also declares tolower, so the qualifier picks the C-locale form of JKAShared.
        letter = CChar(truncatingIfNeeded: JKAShared.tolower(Int32(byte)))
        if letter == Int32(ascii: ".") {
            break // don't include extension
        }
        if letter == Int32(ascii: "\\") {
            letter = CChar(truncatingIfNeeded: Int32(ascii: "/")) // damn path names
        }
        if letter == PATH_SEP {
            letter = CChar(truncatingIfNeeded: Int32(ascii: "/")) // damn path names
        }
        // C widens the `int` factor to `long` for the product.
        hash += CLong(letter) * CLong(i + 119)
        i += 1
    }
    hash = (hash ^ (hash >> 10) ^ (hash >> 20))
    hash &= CLong(size - 1)
    return hash
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:273
func R_RemapShader(_ shaderName: String, _ newShaderName: String, _ timeOffset: String?) {
    var strippedName = CharBuf(MAX_QPATH)
    var hash: Int32
    var sh: Shader?
    var sh2: Shader?
    var h: JKAShared.qhandle_t

    sh = R_FindShaderByName(shaderName)
    if sh == nil || sh == tr.defaultShader {
        h = RE_RegisterShaderLightMap(shaderName, lightmapsNone, stylesDefault)
        sh = R_GetShaderByHandle(h)
    }
    if sh == nil || sh == tr.defaultShader {
        Com_Printf(S_COLOR_YELLOW + "WARNING: R_RemapShader: shader %s not found\n", shaderName)
        return
    }

    sh2 = R_FindShaderByName(newShaderName)
    if sh2 == nil || sh2 == tr.defaultShader {
        h = RE_RegisterShaderLightMap(newShaderName, lightmapsNone, stylesDefault)
        sh2 = R_GetShaderByHandle(h)
    }

    if sh2 == nil || sh2 == tr.defaultShader {
        Com_Printf(S_COLOR_YELLOW + "WARNING: R_RemapShader: new shader %s not found\n", newShaderName)
        return
    }

    // remap all the shaders with the given name
    // even tho they might have different lightmaps
    COM_StripExtension(shaderName, &strippedName)
    hash = Int32(generateHashValue(String(strippedName), FILE_HASH_SIZE))
    sh = hashTable[hash]
    while let s = sh {
        if Q_stricmp(s.name, String(strippedName)) == 0 {
            if s != sh2 {
                s.remappedShader = sh2
            } else {
                s.remappedShader = nil
            }
        }
        sh = s.next
    }
    if timeOffset != nil {
        sh2!.timeOffset = Float(atof(timeOffset!))
    }
}

/**
```
===============
ParseVector
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:323
func ParseVector(_ text: inout JKAShared.TextCursor, _ count: Int32, _ v: inout JKAShared.vec3_t) -> Bool {
    var token: String
    var i: Int32

    // FIXME: spaces are currently required after parens, should change parseext...
    token = COM_ParseExt(&text, false)
    if strcmp(token, "(") != 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing parenthesis in shader '%s'\n", shader.name)
        return false
    }

    i = 0
    while i < count {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing vector element in shader '%s'\n", shader.name)
            return false
        }
        v[i] = Float(atof(token))
        i += 1
    }

    token = COM_ParseExt(&text, false)
    if strcmp(token, ")") != 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing parenthesis in shader '%s'\n", shader.name)
        return false
    }

    return true
}

/**
```
===============
NameToAFunc
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:358
// AI: Raven returns `unsigned`. The return is the Int32 of the masks, because every caller stores it into an `int`.
private func NameToAFunc(_ funcname: String) -> Int32 {
    if Q_stricmp(funcname, "GT0") == 0 {
        return GLS_ATEST_GT_0
    } else if Q_stricmp(funcname, "LT128") == 0 {
        return GLS_ATEST_LT_80
    } else if Q_stricmp(funcname, "GE128") == 0 {
        return GLS_ATEST_GE_80
    } else if Q_stricmp(funcname, "GE192") == 0 {
        // Raven wrote GLS_ATEST_GE_C0, the unsigned 0x80000000.
        return ~0x7fff_ffff
    }

    Com_Printf(S_COLOR_YELLOW + "WARNING: invalid alphaFunc name '%s' in shader '%s'\n", funcname, shader.name)
    return 0
}

/**
```
===============
NameToSrcBlendMode
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:387
private func NameToSrcBlendMode(_ name: String) -> Int32 {
    if Q_stricmp(name, "GL_ONE") == 0 {
        return GLS_SRCBLEND_ONE
    } else if Q_stricmp(name, "GL_ZERO") == 0 {
        return GLS_SRCBLEND_ZERO
    } else if Q_stricmp(name, "GL_DST_COLOR") == 0 {
        return GLS_SRCBLEND_DST_COLOR
    } else if Q_stricmp(name, "GL_ONE_MINUS_DST_COLOR") == 0 {
        return GLS_SRCBLEND_ONE_MINUS_DST_COLOR
    } else if Q_stricmp(name, "GL_SRC_ALPHA") == 0 {
        return GLS_SRCBLEND_SRC_ALPHA
    } else if Q_stricmp(name, "GL_ONE_MINUS_SRC_ALPHA") == 0 {
        return GLS_SRCBLEND_ONE_MINUS_SRC_ALPHA
    } else if Q_stricmp(name, "GL_DST_ALPHA") == 0 {
        return GLS_SRCBLEND_DST_ALPHA
    } else if Q_stricmp(name, "GL_ONE_MINUS_DST_ALPHA") == 0 {
        return GLS_SRCBLEND_ONE_MINUS_DST_ALPHA
    } else if Q_stricmp(name, "GL_SRC_ALPHA_SATURATE") == 0 {
        return GLS_SRCBLEND_ALPHA_SATURATE
    }

    Com_Printf(S_COLOR_YELLOW + "WARNING: unknown blend mode '%s' in shader '%s', substituting GL_ONE\n", name, shader.name)
    return GLS_SRCBLEND_ONE
}

/**
```
===============
NameToDstBlendMode
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:435
private func NameToDstBlendMode(_ name: String) -> Int32 {
    if Q_stricmp(name, "GL_ONE") == 0 {
        return GLS_DSTBLEND_ONE
    } else if Q_stricmp(name, "GL_ZERO") == 0 {
        return GLS_DSTBLEND_ZERO
    } else if Q_stricmp(name, "GL_SRC_ALPHA") == 0 {
        return GLS_DSTBLEND_SRC_ALPHA
    } else if Q_stricmp(name, "GL_ONE_MINUS_SRC_ALPHA") == 0 {
        return GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA
    } else if Q_stricmp(name, "GL_DST_ALPHA") == 0 {
        return GLS_DSTBLEND_DST_ALPHA
    } else if Q_stricmp(name, "GL_ONE_MINUS_DST_ALPHA") == 0 {
        return GLS_DSTBLEND_ONE_MINUS_DST_ALPHA
    } else if Q_stricmp(name, "GL_SRC_COLOR") == 0 {
        return GLS_DSTBLEND_SRC_COLOR
    } else if Q_stricmp(name, "GL_ONE_MINUS_SRC_COLOR") == 0 {
        return GLS_DSTBLEND_ONE_MINUS_SRC_COLOR
    }

    Com_Printf(S_COLOR_YELLOW + "WARNING: unknown blend mode '%s' in shader '%s', substituting GL_ONE\n", name, shader.name)
    return GLS_DSTBLEND_ONE
}

/**
```
===============
NameToGenFunc
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:479
private func NameToGenFunc(_ funcname: String) -> genFunc_t {
    if Q_stricmp(funcname, "sin") == 0 {
        return GF_SIN
    } else if Q_stricmp(funcname, "square") == 0 {
        return GF_SQUARE
    } else if Q_stricmp(funcname, "triangle") == 0 {
        return GF_TRIANGLE
    } else if Q_stricmp(funcname, "sawtooth") == 0 {
        return GF_SAWTOOTH
    } else if Q_stricmp(funcname, "inversesawtooth") == 0 {
        return GF_INVERSE_SAWTOOTH
    } else if Q_stricmp(funcname, "noise") == 0 {
        return GF_NOISE
    } else if Q_stricmp(funcname, "random") == 0 {
        return GF_RAND
    }

    Com_Printf(S_COLOR_YELLOW + "WARNING: invalid genfunc name '%s' in shader '%s'\n", funcname, shader.name)
    return GF_SIN
}

/**
```
===================
ParseWaveForm
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:520
private func ParseWaveForm(_ text: inout JKAShared.TextCursor, _ wave: WaveForm) {
    var token: String

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing waveform parm in shader '%s'\n", shader.name)
        return
    }
    wave.`func` = NameToGenFunc(token)

    // BASE, AMP, PHASE, FREQ
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing waveform parm in shader '%s'\n", shader.name)
        return
    }
    wave.base = Float(atof(token))

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing waveform parm in shader '%s'\n", shader.name)
        return
    }
    wave.amplitude = Float(atof(token))

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing waveform parm in shader '%s'\n", shader.name)
        return
    }
    wave.phase = Float(atof(token))

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing waveform parm in shader '%s'\n", shader.name)
        return
    }
    wave.frequency = Float(atof(token))
}

/**
```
===================
ParseTexMod
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:572
private func ParseTexMod(_ _text: String, _ stage: ShaderStage) {
    // Raven's one call is in ParseStage at tr_shader.cpp:1799, which is dead in the dedicated build, so the function is dead too.
    var token: String
    // Raven's `text` points at his own `_text` parameter, so the body walks a TextCursor over a copy of its bytes.
    var text = TextCursor(CharBuf(_text))
    let tmi: TexModInfo

    if stage.bundle[0].numTexMods == TR_MAX_TEXMODS {
        Com_Error(ERR_DROP, "ERROR: too many tcMod stages in shader '%s'\n", shader.name)
    }

    tmi = stage.bundle[0].texModsSlots[stage.bundle[0].numTexMods]
    stage.bundle[0].numTexMods += 1

    token = COM_ParseExt(&text, false)

    //
    // turb
    //
    if Q_stricmp(token, "turb") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing tcMod turb parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.base = Float(atof(token))
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing tcMod turb in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.amplitude = Float(atof(token))
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing tcMod turb in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.phase = Float(atof(token))
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing tcMod turb in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.frequency = Float(atof(token))

        tmi.type = TMOD_TURBULENT
    }
    //
    // scale
    //
    else if Q_stricmp(token, "scale") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing scale parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[0] = Float(atof(token)) //scale unioned

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing scale parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[1] = Float(atof(token)) //scale unioned
        tmi.type = TMOD_SCALE
    }
    //
    // scroll
    //
    else if Q_stricmp(token, "scroll") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing scale scroll parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[0] = Float(atof(token)) //scroll unioned
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing scale scroll parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[1] = Float(atof(token)) //scroll unioned
        tmi.type = TMOD_SCROLL
    }
    //
    // stretch
    //
    else if Q_stricmp(token, "stretch") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing stretch parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.`func` = NameToGenFunc(token)

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing stretch parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.base = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing stretch parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.amplitude = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing stretch parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.phase = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing stretch parms in shader '%s'\n", shader.name)
            return
        }
        tmi.wave.frequency = Float(atof(token))

        tmi.type = TMOD_STRETCH
    }
    //
    // transform
    //
    else if Q_stricmp(token, "transform") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.matrix[0][0] = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.matrix[0][1] = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.matrix[1][0] = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.matrix[1][1] = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[0] = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing transform parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[1] = Float(atof(token))

        tmi.type = TMOD_TRANSFORM
    }
    //
    // rotate
    //
    else if Q_stricmp(token, "rotate") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing tcMod rotate parms in shader '%s'\n", shader.name)
            return
        }
        tmi.translate[0] = Float(atof(token)) //rotateSpeed unioned
        tmi.type = TMOD_ROTATE
    }
    //
    // entityTranslate
    //
    else if Q_stricmp(token, "entityTranslate") == 0 {
        tmi.type = TMOD_ENTITY_TRANSLATE
    } else {
        Com_Printf(S_COLOR_YELLOW + "WARNING: unknown tcMod '%s' in shader '%s'\n", token, shader.name)
    }
}

/**
```
/////===== Part of the VERTIGON system =====/////
===================
ParseSurfaceSprites
===================
```
*/
// surfaceSprites <type> <width> <height> <density> <fadedist>
//
// NOTE:  This parsing function used to be 12 pages long and very complex.  The new version of surfacesprites
// utilizes optional parameters parsed in ParseSurfaceSpriteOptional.
/// Source: oracle/codemp/renderer/tr_shader.cpp:808
private func ParseSurfaceSprites(_ _text: String, _ stage: ShaderStage) {
    // Raven's one call is in ParseStage at tr_shader.cpp:1836, which is dead in the dedicated build, so the function is dead too.
    var token: String
    // Raven's `text` points at his own `_text` parameter, so the body walks a TextCursor over a copy of its bytes.
    var text = TextCursor(CharBuf(_text))
    let width: Float
    let height: Float
    let density: Float
    let fadedist: Float
    var sstype: Int32 = SURFSPRITE_NONE

    //
    // spritetype
    //
    token = COM_ParseExt(&text, false)

    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfaceSprites params in shader '%s'\n", shader.name)
        return
    }

    if Q_stricmp(token, "vertical") == 0 {
        sstype = SURFSPRITE_VERTICAL
    } else if Q_stricmp(token, "oriented") == 0 {
        sstype = SURFSPRITE_ORIENTED
    } else if Q_stricmp(token, "effect") == 0 {
        sstype = SURFSPRITE_EFFECT
    } else {
        Com_Printf(S_COLOR_YELLOW + "WARNING: invalid type in shader '%s'\n", shader.name)
        return
    }

    //
    // width
    //
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfaceSprites params in shader '%s'\n", shader.name)
        return
    }
    width = Float(atof(token))
    if width <= 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: invalid width in shader '%s'\n", shader.name)
        return
    }

    //
    // height
    //
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfaceSprites params in shader '%s'\n", shader.name)
        return
    }
    height = Float(atof(token))
    if height <= 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: invalid height in shader '%s'\n", shader.name)
        return
    }

    //
    // density
    //
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfaceSprites params in shader '%s'\n", shader.name)
        return
    }
    density = Float(atof(token))
    if density <= 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: invalid density in shader '%s'\n", shader.name)
        return
    }

    //
    // fadedist
    //
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfaceSprites params in shader '%s'\n", shader.name)
        return
    }
    fadedist = Float(atof(token))
    if fadedist < 32 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: invalid fadedist (%f < 32) in shader '%s'\n", fadedist, shader.name)
        return
    }

    if stage.ss == nil {
        stage.ss = SurfaceSprite(Hunk_Alloc(Int32(SurfaceSprite.byteCount), h_low))
    }
    let ss = stage.ss!

    // These are all set by the command lines.
    ss.surfaceSpriteType = sstype
    ss.width = width
    ss.height = height
    ss.density = density
    ss.fadeDist = fadedist

    // These are defaults that can be overwritten.
    // C multiplies in `double`, because `1.33` is a double, and converts the product to `float` at the store.
    ss.fadeMax = Float(Double(fadedist) * 1.33)
    ss.fadeScale = 0.0
    ss.wind = 0.0
    ss.windIdle = 0.0
    ss.variance[0] = 0.0
    ss.variance[1] = 0.0
    ss.facing = SURFSPRITE_FACING_NORMAL

    // A vertical parameter that needs a default regardless
    _ = ss.vertSkew

    // These are effect parameters that need defaults nonetheless.
    ss.fxDuration = 1000 // 1 second
    ss.fxGrow[0] = 0.0
    ss.fxGrow[1] = 0.0
    ss.fxAlphaStart = 1.0
    ss.fxAlphaEnd = 0.0
}

/**
```
/////===== Part of the VERTIGON system =====/////
===========================
ParseSurfaceSpritesOptional
===========================
```
*/
//
// ssFademax <fademax>
// ssFadescale <fadescale>
// ssVariance <varwidth> <varheight>
// ssHangdown
// ssAnyangle
// ssFaceup
// ssWind <wind>
// ssWindIdle <windidle>
// ssVertSkew <skew>
// ssFXDuration <duration>
// ssFXGrow <growwidth> <growheight>
// ssFXAlphaRange <alphastart> <startend>
// ssFXWeather
//
// Optional parameters that will override the defaults set in the surfacesprites command above.
//
/// Source: oracle/codemp/renderer/tr_shader.cpp:970
private func ParseSurfaceSpritesOptional(_ param: String, _ _text: String, _ stage: ShaderStage) {
    // Raven's one call is in ParseStage at tr_shader.cpp:1868, which is dead in the dedicated build, so the function is dead too.
    var token: String
    // Raven's `text` points at his own `_text` parameter, so the body walks a TextCursor over a copy of its bytes.
    var text = TextCursor(CharBuf(_text))
    var value: Float

    if stage.ss == nil {
        stage.ss = SurfaceSprite(Hunk_Alloc(Int32(SurfaceSprite.byteCount), h_low))
    }
    let ss = stage.ss!
    //
    // fademax
    //
    if Q_stricmp(param, "ssFademax") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite fademax in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value <= ss.fadeDist {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite fademax (%.2f <= fadeDist(%.2f)) in shader '%s'\n", value, ss.fadeDist, shader.name)
            return
        }
        ss.fadeMax = value
        return
    }

    //
    // fadescale
    //
    if Q_stricmp(param, "ssFadescale") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite fadescale in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        ss.fadeScale = value
        return
    }

    //
    // variance
    //
    if Q_stricmp(param, "ssVariance") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite variance width in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite variance width in shader '%s'\n", shader.name)
            return
        }
        ss.variance[0] = value

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite variance height in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite variance height in shader '%s'\n", shader.name)
            return
        }
        ss.variance[1] = value
        return
    }

    //
    // hangdown
    //
    if Q_stricmp(param, "ssHangdown") == 0 {
        if ss.facing != SURFSPRITE_FACING_NORMAL {
            Com_Printf(S_COLOR_YELLOW + "WARNING: Hangdown facing overrides previous facing in shader '%s'\n", shader.name)
            return
        }
        ss.facing = SURFSPRITE_FACING_DOWN
        return
    }

    //
    // anyangle
    //
    if Q_stricmp(param, "ssAnyangle") == 0 {
        if ss.facing != SURFSPRITE_FACING_NORMAL {
            Com_Printf(S_COLOR_YELLOW + "WARNING: Anyangle facing overrides previous facing in shader '%s'\n", shader.name)
            return
        }
        ss.facing = SURFSPRITE_FACING_ANY
        return
    }

    //
    // faceup
    //
    if Q_stricmp(param, "ssFaceup") == 0 {
        if ss.facing != SURFSPRITE_FACING_NORMAL {
            Com_Printf(S_COLOR_YELLOW + "WARNING: Faceup facing overrides previous facing in shader '%s'\n", shader.name)
            return
        }
        ss.facing = SURFSPRITE_FACING_UP
        return
    }

    //
    // wind
    //
    if Q_stricmp(param, "ssWind") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite wind in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0.0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite wind in shader '%s'\n", shader.name)
            return
        }
        ss.wind = value
        if ss.windIdle <= 0 { // Also override the windidle, it usually is the same as wind
            ss.windIdle = value
        }
        return
    }

    //
    // windidle
    //
    if Q_stricmp(param, "ssWindidle") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite windidle in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0.0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite windidle in shader '%s'\n", shader.name)
            return
        }
        ss.windIdle = value
        return
    }

    //
    // vertskew
    //
    if Q_stricmp(param, "ssVertskew") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite vertskew in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0.0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite vertskew in shader '%s'\n", shader.name)
            return
        }
        ss.vertSkew = value
        return
    }

    //
    // fxduration
    //
    if Q_stricmp(param, "ssFXDuration") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite duration in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value <= 0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite duration in shader '%s'\n", shader.name)
            return
        }
        ss.fxDuration = value
        return
    }

    //
    // fxgrow
    //
    if Q_stricmp(param, "ssFXGrow") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite grow width in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite grow width in shader '%s'\n", shader.name)
            return
        }
        ss.fxGrow[0] = value

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite grow height in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite grow height in shader '%s'\n", shader.name)
            return
        }
        ss.fxGrow[1] = value
        return
    }

    //
    // fxalpharange
    //
    if Q_stricmp(param, "ssFXAlphaRange") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite fxalpha start in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 || value > 1.0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite fxalpha start in shader '%s'\n", shader.name)
            return
        }
        ss.fxAlphaStart = value

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing surfacesprite fxalpha end in shader '%s'\n", shader.name)
            return
        }
        value = Float(atof(token))
        if value < 0 || value > 1.0 {
            Com_Printf(S_COLOR_YELLOW + "WARNING: invalid surfacesprite fxalpha end in shader '%s'\n", shader.name)
            return
        }
        ss.fxAlphaEnd = value
        return
    }

    //
    // fxweather
    //
    if Q_stricmp(param, "ssFXWeather") == 0 {
        if ss.surfaceSpriteType != SURFSPRITE_EFFECT {
            Com_Printf(S_COLOR_YELLOW + "WARNING: weather applied to non-effect surfacesprite in shader '%s'\n", shader.name)
            return
        }
        ss.surfaceSpriteType = SURFSPRITE_WEATHERFX
        return
    }

    //
    // invalid ss command.
    //
    Com_Printf(S_COLOR_YELLOW + "WARNING: invalid optional surfacesprite param '%s' in shader '%s'\n", param, shader.name)
    return
}

/**
```
===================
ParseStage
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:1279
private func ParseStage(_ stage: ShaderStage, _ text: inout JKAShared.TextCursor) -> Bool {
    // Raven's one call is in ParseShader at tr_shader.cpp:2336, which is dead in the dedicated build, so the function is dead too.
    var token: String
    var depthMaskBits: Int32 = GLS_DEPTHMASK_TRUE
    var blendSrcBits: Int32 = 0
    var blendDstBits: Int32 = 0
    var atestBits: Int32 = 0
    var depthFuncBits: Int32 = 0
    var depthMaskExplicit = false

    stage.active = true

    while true {
        token = COM_ParseExt(&text, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: no matching '}' found\n")
            return false
        }

        if CharBuf(token)[0] == Int32(ascii: "}") {
            break
        }
        //
        // map <name>
        //
        else if Q_stricmp(token, "map") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for 'map' keyword in shader '%s'\n", shader.name)
                return false
            }

            if Q_stricmp(token, "$whiteimage") == 0 {
                stage.bundle[0].image = tr.whiteImage
                continue
            } else if Q_stricmp(token, "$lightmap") == 0 {
                stage.bundle[0].isLightmap = true
                if shader.lightmapIndex[0] < 0 || shader.lightmapIndex[0] >= tr.numLightmaps {
                    Com_Printf(S_COLOR_RED + "Lightmap requested but none available for shader %s\n", shader.name)
                    stage.bundle[0].image = tr.whiteImage
                } else {
                    stage.bundle[0].image = tr.lightmaps[shader.lightmapIndex[0]]
                }
                continue
            } else {
                stage.bundle[0].image = nil
                return false
            }
        }
        //
        // clampmap <name>
        //
        else if Q_stricmp(token, "clampmap") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for 'clampmap' keyword in shader '%s'\n", shader.name)
                return false
            }
            stage.bundle[0].image = nil
            return false
        }
        //
        // animMap <frequency> <image1> .... <imageN>
        //
        else if Q_stricmp(token, "animMap") == 0 || Q_stricmp(token, "clampanimMap") == 0 || Q_stricmp(token, "oneshotanimMap") == 0 {
            // AI: Raven declares `image_t *images[MAX_IMAGE_ANIMATIONS]` on the stack. The local is a Swift array of optional views, and the dedicated arm never writes it.
            let images = [Image?](repeating: nil, count: Int(MAX_IMAGE_ANIMATIONS))
            let bClamp = Q_stricmp(token, "clampanimMap") == 0
            let oneShot = Q_stricmp(token, "oneshotanimMap") == 0

            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for '%s' keyword in shader '%s'\n", bClamp ? "animMap" : "clampanimMap", shader.name)
                return false
            }
            stage.bundle[0].imageAnimationSpeed = Float(atof(token))
            stage.bundle[0].oneShotAnimMap = oneShot

            // parse up to MAX_IMAGE_ANIMATIONS animations
            while true {
                var num: Int32

                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    break
                }
                num = stage.bundle[0].numImageAnimations
                if num < MAX_IMAGE_ANIMATIONS {
                    stage.bundle[0].image = nil
                    return false
                }
            }
            // Copy image ptrs into an array of ptrs
            let block = Hunk_Alloc(stage.bundle[0].numImageAnimations * Int32(OpaquePointer.byteCount), h_low)
            stage.bundle[0].image = Image(block)
            // AI: Raven copies the pointers with memcpy. `images` is a Swift array, so a loop copies each pointer into a Slots over the block.
            let imageSlots = Slots<Image?>(pointers: block, count: Int(stage.bundle[0].numImageAnimations))
            var i: Int32 = 0
            while i < stage.bundle[0].numImageAnimations {
                imageSlots[i] = images[i]
                i += 1
            }
        } else if Q_stricmp(token, "videoMap") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for 'videoMap' keyword in shader '%s'\n", shader.name)
                return false
            }
            stage.bundle[0].videoMapHandle = -1
            if stage.bundle[0].videoMapHandle != -1 {
                stage.bundle[0].isVideoMap = true
                assert(stage.bundle[0].videoMapHandle < NUM_SCRATCH_IMAGES)
                stage.bundle[0].image = tr.scratchImage[stage.bundle[0].videoMapHandle]
            }
        }
        //
        // alphafunc <func>
        //
        else if Q_stricmp(token, "alphaFunc") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for 'alphaFunc' keyword in shader '%s'\n", shader.name)
                return false
            }

            atestBits = NameToAFunc(token)
        }
        //
        // depthFunc <func>
        //
        else if Q_stricmp(token, "depthfunc") == 0 {
            token = COM_ParseExt(&text, false)

            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameter for 'depthfunc' keyword in shader '%s'\n", shader.name)
                return false
            }

            if Q_stricmp(token, "lequal") == 0 {
                depthFuncBits = 0
            } else if Q_stricmp(token, "equal") == 0 {
                depthFuncBits = GLS_DEPTHFUNC_EQUAL
            } else if Q_stricmp(token, "disable") == 0 {
                depthFuncBits = GLS_DEPTHTEST_DISABLE
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: unknown depthfunc '%s' in shader '%s'\n", token, shader.name)
                continue
            }
        }
        //
        // detail
        //
        else if Q_stricmp(token, "detail") == 0 {
            stage.isDetail = true
        }
        //
        // blendfunc <srcFactor> <dstFactor>
        // or blendfunc <add|filter|blend>
        //
        else if Q_stricmp(token, "blendfunc") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parm for blendFunc in shader '%s'\n", shader.name)
                continue
            }
            // check for "simple" blends first
            if Q_stricmp(token, "add") == 0 {
                blendSrcBits = GLS_SRCBLEND_ONE
                blendDstBits = GLS_DSTBLEND_ONE
            } else if Q_stricmp(token, "filter") == 0 {
                blendSrcBits = GLS_SRCBLEND_DST_COLOR
                blendDstBits = GLS_DSTBLEND_ZERO
            } else if Q_stricmp(token, "blend") == 0 {
                blendSrcBits = GLS_SRCBLEND_SRC_ALPHA
                blendDstBits = GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA
            } else {
                // complex double blends
                blendSrcBits = NameToSrcBlendMode(token)

                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    Com_Printf(S_COLOR_YELLOW + "WARNING: missing parm for blendFunc in shader '%s'\n", shader.name)
                    continue
                }
                blendDstBits = NameToDstBlendMode(token)
            }

            // clear depth mask for blended surfaces
            if !depthMaskExplicit {
                depthMaskBits = 0
            }
        }
        //
        // rgbGen
        //
        else if Q_stricmp(token, "rgbGen") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameters for rgbGen in shader '%s'\n", shader.name)
                continue
            }

            if Q_stricmp(token, "wave") == 0 {
                ParseWaveForm(&text, stage.rgbWave)
                stage.rgbGen = CGEN_WAVEFORM
            } else if Q_stricmp(token, "const") == 0 {
                var color = vec3_t()

                _ = ParseVector(&text, 3, &color)
                // C converts each float product to the byte at the store.
                // Port-note: Raven converts a product outside 0 to 255 to `byte`, undefined.
                // The Swift keeps the low byte, and the Int32 conversion traps on a NaN or a value past Int32, rule 19.
                stage.constantColor[0] = UInt8(truncatingIfNeeded: Int32(255 * color[0]))
                stage.constantColor[1] = UInt8(truncatingIfNeeded: Int32(255 * color[1]))
                stage.constantColor[2] = UInt8(truncatingIfNeeded: Int32(255 * color[2]))

                stage.rgbGen = CGEN_CONST
            } else if Q_stricmp(token, "identity") == 0 {
                stage.rgbGen = CGEN_IDENTITY
            } else if Q_stricmp(token, "identityLighting") == 0 {
                stage.rgbGen = CGEN_IDENTITY_LIGHTING
            } else if Q_stricmp(token, "entity") == 0 {
                stage.rgbGen = CGEN_ENTITY
            } else if Q_stricmp(token, "oneMinusEntity") == 0 {
                stage.rgbGen = CGEN_ONE_MINUS_ENTITY
            } else if Q_stricmp(token, "vertex") == 0 {
                stage.rgbGen = CGEN_VERTEX
                if stage.alphaGen == 0 {
                    stage.alphaGen = AGEN_VERTEX
                }
            } else if Q_stricmp(token, "exactVertex") == 0 {
                stage.rgbGen = CGEN_EXACT_VERTEX
            } else if Q_stricmp(token, "lightingDiffuse") == 0 {
                stage.rgbGen = CGEN_LIGHTING_DIFFUSE
            } else if Q_stricmp(token, "lightingDiffuseEntity") == 0 {
                if shader.lightmapIndex[0] != LIGHTMAP_NONE {
                    Com_Printf(S_COLOR_RED + "ERROR: rgbGen lightingDiffuseEntity used on a misc_model! in shader '%s'\n", shader.name)
                }
                stage.rgbGen = CGEN_LIGHTING_DIFFUSE_ENTITY
            } else if Q_stricmp(token, "oneMinusVertex") == 0 {
                stage.rgbGen = CGEN_ONE_MINUS_VERTEX
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: unknown rgbGen parameter '%s' in shader '%s'\n", token, shader.name)
                continue
            }
        }
        //
        // alphaGen
        //
        else if Q_stricmp(token, "alphaGen") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parameters for alphaGen in shader '%s'\n", shader.name)
                continue
            }

            if Q_stricmp(token, "wave") == 0 {
                ParseWaveForm(&text, stage.alphaWave)
                stage.alphaGen = AGEN_WAVEFORM
            } else if Q_stricmp(token, "const") == 0 {
                token = COM_ParseExt(&text, false)
                // C multiplies in `double`, because `atof` returns a double, and converts the product to the byte at the store.
                // Port-note: Raven converts a product outside 0 to 255 to `byte`, undefined.
                // The Swift keeps the low byte, and the Int32 conversion traps on a NaN or a value past Int32, rule 19.
                stage.constantColor[3] = UInt8(truncatingIfNeeded: Int32(255 * atof(token)))
                stage.alphaGen = AGEN_CONST
            } else if Q_stricmp(token, "identity") == 0 {
                stage.alphaGen = AGEN_IDENTITY
            } else if Q_stricmp(token, "entity") == 0 {
                stage.alphaGen = AGEN_ENTITY
            } else if Q_stricmp(token, "oneMinusEntity") == 0 {
                stage.alphaGen = AGEN_ONE_MINUS_ENTITY
            } else if Q_stricmp(token, "vertex") == 0 {
                stage.alphaGen = AGEN_VERTEX
            } else if Q_stricmp(token, "lightingSpecular") == 0 {
                stage.alphaGen = AGEN_LIGHTING_SPECULAR
            } else if Q_stricmp(token, "oneMinusVertex") == 0 {
                stage.alphaGen = AGEN_ONE_MINUS_VERTEX
            } else if Q_stricmp(token, "dot") == 0 {
                stage.alphaGen = AGEN_DOT
            } else if Q_stricmp(token, "oneMinusDot") == 0 {
                stage.alphaGen = AGEN_ONE_MINUS_DOT
            } else if Q_stricmp(token, "portal") == 0 {
                stage.alphaGen = AGEN_PORTAL
                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    shader.portalRange = 256
                    Com_Printf(S_COLOR_YELLOW + "WARNING: missing range parameter for alphaGen portal in shader '%s', defaulting to 256\n", shader.name)
                } else {
                    shader.portalRange = Float(atof(token))
                }
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: unknown alphaGen parameter '%s' in shader '%s'\n", token, shader.name)
                continue
            }
        }
        //
        // tcGen <function>
        //
        else if Q_stricmp(token, "texgen") == 0 || Q_stricmp(token, "tcGen") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing texgen parm in shader '%s'\n", shader.name)
                continue
            }

            if Q_stricmp(token, "environment") == 0 {
                stage.bundle[0].tcGen = TCGEN_ENVIRONMENT_MAPPED
            } else if Q_stricmp(token, "lightmap") == 0 {
                stage.bundle[0].tcGen = TCGEN_LIGHTMAP
            } else if Q_stricmp(token, "texture") == 0 || Q_stricmp(token, "base") == 0 {
                stage.bundle[0].tcGen = TCGEN_TEXTURE
            } else if Q_stricmp(token, "vector") == 0 {
                stage.bundle[0].tcGenVectors = Slots(vectors: Hunk_Alloc(2 * Int32(vec3_t.byteCount), h_low), count: 2)
                _ = ParseVector(&text, 3, &stage.bundle[0].tcGenVectors![0])
                _ = ParseVector(&text, 3, &stage.bundle[0].tcGenVectors![1])

                stage.bundle[0].tcGen = TCGEN_VECTOR
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: unknown texgen parm in shader '%s'\n", shader.name)
            }
        }
        //
        // tcMod <type> <...>
        //
        else if Q_stricmp(token, "tcMod") == 0 {
            var buffer = CharBuf(1024)

            while true {
                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    break
                }
                strcat(&buffer, token)
                strcat(&buffer, " ")
            }

            ParseTexMod(String(buffer), stage)

            continue
        }
        //
        // depthmask
        //
        else if Q_stricmp(token, "depthwrite") == 0 {
            depthMaskBits = GLS_DEPTHMASK_TRUE
            depthMaskExplicit = true

            continue
        }
        // If this stage has glow...	GLOWXXX
        else if Q_stricmp(token, "glow") == 0 {
            stage.glow = true

            continue
        }
        //
        // surfaceSprites <type> ...
        //
        else if Q_stricmp(token, "surfaceSprites") == 0 {
            var buffer = CharBuf(1024)

            while true {
                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    break
                }
                strcat(&buffer, token)
                strcat(&buffer, " ")
            }

            ParseSurfaceSprites(String(buffer), stage)

            continue
        }
        //
        // ssFademax <fademax>
        // ssFadescale <fadescale>
        // ssVariance <varwidth> <varheight>
        // ssHangdown
        // ssAnyangle
        // ssFaceup
        // ssWind <wind>
        // ssWindIdle <windidle>
        // ssDuration <duration>
        // ssGrow <growwidth> <growheight>
        // ssWeather
        //
        else if Q_stricmpn(token, "ss", 2) == 0 { // <--- NOTE ONLY COMPARING FIRST TWO LETTERS
            var buffer = CharBuf(1024)
            var param = CharBuf(128)
            strcpy(&param, token)

            while true {
                token = COM_ParseExt(&text, false)
                if token.isEmpty {
                    break
                }
                strcat(&buffer, token)
                strcat(&buffer, " ")
            }

            ParseSurfaceSpritesOptional(String(param), String(buffer), stage)

            continue
        } else {
            Com_Printf(S_COLOR_YELLOW + "WARNING: unknown parameter '%s' in shader '%s'\n", token, shader.name)
            return false
        }
    }

    //
    // if cgen isn't explicitly specified, use either identity or identitylighting
    //
    if stage.rgbGen == CGEN_BAD {
        if //blendSrcBits == 0 ||
            blendSrcBits == GLS_SRCBLEND_ONE ||
            blendSrcBits == GLS_SRCBLEND_SRC_ALPHA
        {
            stage.rgbGen = CGEN_IDENTITY_LIGHTING
        } else {
            stage.rgbGen = CGEN_IDENTITY
        }
    }

    //
    // implicitly assume that a GL_ONE GL_ZERO blend mask disables blending
    //
    if (blendSrcBits == GLS_SRCBLEND_ONE) &&
        (blendDstBits == GLS_DSTBLEND_ZERO)
    {
        blendSrcBits = 0
        blendDstBits = blendSrcBits
        depthMaskBits = GLS_DEPTHMASK_TRUE
    }

    // decide which agens we can skip
    if stage.alphaGen == AGEN_IDENTITY {
        if stage.rgbGen == CGEN_IDENTITY ||
            stage.rgbGen == CGEN_LIGHTING_DIFFUSE
        {
            stage.alphaGen = AGEN_SKIP
        }
    }

    //
    // compute state bits
    //
    stage.stateBits = UInt32(bitPattern: depthMaskBits |
        blendSrcBits | blendDstBits |
        atestBits |
        depthFuncBits)

    return true
}

/**
```
===============
ParseDeform

deformVertexes wave <spread> <waveform> <base> <amplitude> <phase> <frequency>
deformVertexes normal <frequency> <amplitude>
deformVertexes move <vector> <waveform> <base> <amplitude> <phase> <frequency>
deformVertexes bulge <bulgeWidth> <bulgeHeight> <bulgeSpeed>
deformVertexes projectionShadow
deformVertexes autoSprite
deformVertexes autoSprite2
deformVertexes text[0-7]
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:1936
private func ParseDeform(_ text: inout JKAShared.TextCursor) {
    // Raven's one call is in ParseShader at tr_shader.cpp:2408, which is dead in the dedicated build, so the function is dead too.
    var token: String
    let ds: DeformStage

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing deform parm in shader '%s'\n", shader.name)
        return
    }

    if shader.numDeforms == MAX_SHADER_DEFORMS {
        Com_Printf(S_COLOR_YELLOW + "WARNING: MAX_SHADER_DEFORMS in '%s'\n", shader.name)
        return
    }

    shader.deforms[shader.numDeforms] = DeformStage(Hunk_Alloc(Int32(DeformStage.byteCount), h_low))

    ds = shader.deforms[shader.numDeforms]!
    shader.numDeforms += 1

    if Q_stricmp(token, "projectionShadow") == 0 {
        ds.deformation = DEFORM_PROJECTION_SHADOW
        return
    }

    if Q_stricmp(token, "autosprite") == 0 {
        ds.deformation = DEFORM_AUTOSPRITE
        return
    }

    if Q_stricmp(token, "autosprite2") == 0 {
        ds.deformation = DEFORM_AUTOSPRITE2
        return
    }

    if Q_stricmpn(token, "text", 4) == 0 {
        var n: Int32

        n = CharBuf(token)[4] - Int32(ascii: "0")
        if n < 0 || n > 7 {
            n = 0
        }
        ds.deformation = DEFORM_TEXT0 + n
        return
    }

    if Q_stricmp(token, "bulge") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes bulge parm in shader '%s'\n", shader.name)
            return
        }
        ds.bulgeWidth = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes bulge parm in shader '%s'\n", shader.name)
            return
        }
        ds.bulgeHeight = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes bulge parm in shader '%s'\n", shader.name)
            return
        }
        ds.bulgeSpeed = Float(atof(token))

        ds.deformation = DEFORM_BULGE
        return
    }

    if Q_stricmp(token, "wave") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes parm in shader '%s'\n", shader.name)
            return
        }

        if atof(token) != 0 {
            // C divides in `double`, because `atof` returns a double, and converts the quotient to `float` at the store.
            ds.deformationSpread = Float(1.0 / atof(token))
        } else {
            ds.deformationSpread = 100.0
            Com_Printf(S_COLOR_YELLOW + "WARNING: illegal div value of 0 in deformVertexes command for shader '%s'\n", shader.name)
        }

        ParseWaveForm(&text, ds.deformationWave)
        ds.deformation = DEFORM_WAVE
        return
    }

    if Q_stricmp(token, "normal") == 0 {
        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes parm in shader '%s'\n", shader.name)
            return
        }
        ds.deformationWave.amplitude = Float(atof(token))

        token = COM_ParseExt(&text, false)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes parm in shader '%s'\n", shader.name)
            return
        }
        ds.deformationWave.frequency = Float(atof(token))

        ds.deformation = DEFORM_NORMALS
        return
    }

    if Q_stricmp(token, "move") == 0 {
        var i: Int32

        i = 0
        while i < 3 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing deformVertexes parm in shader '%s'\n", shader.name)
                return
            }
            ds.moveVector[i] = Float(atof(token))
            i += 1
        }

        ParseWaveForm(&text, ds.deformationWave)
        ds.deformation = DEFORM_MOVE
        return
    }

    Com_Printf(S_COLOR_YELLOW + "WARNING: unknown deformVertexes subtype '%s' found in shader '%s'\n", token, shader.name)
}

/**
```
===============
ParseSkyParms

skyParms <outerbox> <cloudheight> <innerbox>
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2086
private func ParseSkyParms(_ text: inout JKAShared.TextCursor) {
    var token: String
    let suf: [String] = ["rt", "lf", "bk", "ft", "up", "dn"]
    var pathname = CharBuf(MAX_QPATH)
    var i: Int32

    shader.sky = SkyParms(Hunk_Alloc(Int32(SkyParms.byteCount), h_low))

    // outerbox
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: 'skyParms' missing parameter in shader '%s'\n", shader.name)
        return
    }
    if strcmp(token, "-") != 0 {
        i = 0
        while i < 6 {
            Com_sprintf(&pathname, Int32(pathname.count), "%s_%s", token, suf[i])
            shader.sky!.outerbox[i] = nil
            i += 1
        }
    }

    // cloudheight
    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: 'skyParms' missing cloudheight in shader '%s'\n", shader.name)
        return
    }
    shader.sky!.cloudHeight = Float(atof(token))
    if shader.sky!.cloudHeight == 0 {
        shader.sky!.cloudHeight = 512
    }

    // innerbox
    token = COM_ParseExt(&text, false)
    if strcmp(token, "-") != 0 {
        Com_Printf(S_COLOR_YELLOW + "WARNING: in shader '%s' 'skyParms', innerbox is not supported!", shader.name)
    }
}

/**
```
=================
ParseSort
=================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2145
private func ParseSort(_ text: inout JKAShared.TextCursor) {
    var token: String

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing sort parameter in shader '%s'\n", shader.name)
        return
    }

    if Q_stricmp(token, "portal") == 0 {
        shader.sort = Float(SS_PORTAL)
    } else if Q_stricmp(token, "sky") == 0 {
        shader.sort = Float(SS_ENVIRONMENT)
    } else if Q_stricmp(token, "opaque") == 0 {
        shader.sort = Float(SS_OPAQUE)
    } else if Q_stricmp(token, "decal") == 0 {
        shader.sort = Float(SS_DECAL)
    } else if Q_stricmp(token, "seeThrough") == 0 {
        shader.sort = Float(SS_SEE_THROUGH)
    } else if Q_stricmp(token, "banner") == 0 {
        shader.sort = Float(SS_BANNER)
    } else if Q_stricmp(token, "additive") == 0 {
        shader.sort = Float(SS_BLEND1)
    } else if Q_stricmp(token, "nearest") == 0 {
        shader.sort = Float(SS_NEAREST)
    } else if Q_stricmp(token, "underwater") == 0 {
        shader.sort = Float(SS_UNDERWATER)
    } else if Q_stricmp(token, "inside") == 0 {
        shader.sort = Float(SS_INSIDE)
    } else if Q_stricmp(token, "mid_inside") == 0 {
        shader.sort = Float(SS_MID_INSIDE)
    } else if Q_stricmp(token, "middle") == 0 {
        shader.sort = Float(SS_MIDDLE)
    } else if Q_stricmp(token, "mid_outside") == 0 {
        shader.sort = Float(SS_MID_OUTSIDE)
    } else if Q_stricmp(token, "outside") == 0 {
        shader.sort = Float(SS_OUTSIDE)
    } else {
        shader.sort = Float(atof(token))
    }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:2198
func ParseMaterial(_ text: inout JKAShared.TextCursor) {
    var token: String
    var i: Int32

    token = COM_ParseExt(&text, false)
    if token.isEmpty {
        Com_Printf(S_COLOR_YELLOW + "WARNING: missing material in shader '%s'\n", shader.name)
        return
    }
    i = 0
    while i < MATERIAL_LAST {
        if Q_stricmp(token, materialNames[i]) == 0 {
            shader.surfaceFlags |= i
            break
        }
        i += 1
    }
}

/**
```
===============
ParseSurfaceParm

surfaceparm <name>
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2275
private func ParseSurfaceParm(_ text: inout JKAShared.TextCursor) {
    let token: String
    let numInfoParms = infoParms.count
    var i: Int32

    token = COM_ParseExt(&text, false)
    i = 0
    while i < numInfoParms {
        if Q_stricmp(token, infoParms[i].name) == 0 {
            shader.surfaceFlags |= infoParms[i].surfaceFlags
            shader.contentFlags |= infoParms[i].contents
            shader.contentFlags &= infoParms[i].clearSolid
            break
        }
        i += 1
    }
}

/**
```
=================
ParseShader

The current text pointer is at the explicit text definition of the
shader.  Parse it into the global shader variable.  Later functions
will optimize it.
=================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2300
private func ParseShader(_ text: inout JKAShared.TextCursor) -> Bool {
    // R_FindShader calls it only on a text that ScanAndLoadShaderFiles loads under `#ifndef DEDICATED` at tr_shader.cpp:3812, so the function is dead in the dedicated build.
    var token: String
    var s: Int32

    s = 0

    token = COM_ParseExt(&text, true)
    if CharBuf(token)[0] != Int32(ascii: "{") {
        Com_Printf(S_COLOR_YELLOW + "WARNING: expecting '{', found '%s' instead in shader '%s'\n", token, shader.name)
        return false
    }

    while true {
        token = COM_ParseExt(&text, true)
        if token.isEmpty {
            Com_Printf(S_COLOR_YELLOW + "WARNING: no concluding '}' in shader %s\n", shader.name)
            return false
        }

        // end of shader definition
        if CharBuf(token)[0] == Int32(ascii: "}") {
            break
        }
        // stage definition
        else if CharBuf(token)[0] == Int32(ascii: "{") {
            if !ParseStage(stages[s], &text) {
                return false
            }
            stages[s].active = true
            // GLOWXXX
            if stages[s].glow {
                shader.hasGlow = true
            }
            s += 1
            continue
        }
        // skip stuff that only the QuakeEdRadient needs
        else if Q_stricmpn(token, "qer", 3) == 0 {
            SkipRestOfLine(&text)
            continue
        }
        // material deprecated as of 11 Jan 01
        // material undeprecated as of 7 May 01 - q3map_material deprecated
        else if Q_stricmp(token, "material") == 0 || Q_stricmp(token, "q3map_material") == 0 {
            ParseMaterial(&text)
        }
        // sun parms
        else if Q_stricmp(token, "sun") == 0 || Q_stricmp(token, "q3map_sun") == 0 {
            token = COM_ParseExt(&text, false)
            tr.sunLight[0] = Float(atof(token))
            token = COM_ParseExt(&text, false)
            tr.sunLight[1] = Float(atof(token))
            token = COM_ParseExt(&text, false)
            tr.sunLight[2] = Float(atof(token))

            _ = VectorNormalize(&tr.sunLight)

            token = COM_ParseExt(&text, false)
            var a = Float(atof(token))
            tr.sunLight = tr.sunLight * a

            token = COM_ParseExt(&text, false)
            a = Float(atof(token))
            // JKAShared's M_PI is the float of Raven's macro at q_shared.h:548, and the qualifier breaks the tie with the double of Foundation.
            a = a / 180 * JKAShared.M_PI

            token = COM_ParseExt(&text, false)
            var b = Float(atof(token))
            b = b / 180 * JKAShared.M_PI

            tr.sunDirection[0] = cos(a) * cos(b)
            tr.sunDirection[1] = sin(a) * cos(b)
            tr.sunDirection[2] = sin(b)
        }
        // q3map_surfacelight deprecated as of 16 Jul 01
        else if Q_stricmp(token, "surfacelight") == 0 || Q_stricmp(token, "q3map_surfacelight") == 0 {
            token = COM_ParseExt(&text, false)
            tr.sunSurfaceLight = atoi(token)
        } else if Q_stricmp(token, "lightColor") == 0 {
            /*
            if ( !ParseVector( text, 3, tr.sunAmbient ) )
            {
            	return qfalse;
            }
            */
            //SP skips this so I'm skipping it here too.
            SkipRestOfLine(&text)
            continue
        } else if Q_stricmp(token, "deformvertexes") == 0 || Q_stricmp(token, "deform") == 0 {
            ParseDeform(&text)
            continue
        } else if Q_stricmp(token, "tesssize") == 0 {
            SkipRestOfLine(&text)
            continue
        } else if Q_stricmp(token, "clampTime") == 0 {
            token = COM_ParseExt(&text, false)
            if !token.isEmpty {
                shader.clampTime = Float(atof(token))
            }
        }
        // skip stuff that only the q3map needs
        else if Q_stricmpn(token, "q3map", 5) == 0 {
            SkipRestOfLine(&text)
            continue
        }
        // skip stuff that only q3map or the server needs
        else if Q_stricmp(token, "surfaceParm") == 0 {
            ParseSurfaceParm(&text)
            continue
        }
        // no mip maps
        else if Q_stricmp(token, "nomipmaps") == 0 {
            shader.noMipMaps = true
            shader.noPicMip = true
            continue
        }
        // no picmip adjustment
        else if Q_stricmp(token, "nopicmip") == 0 {
            shader.noPicMip = true
            continue
        } else if Q_stricmp(token, "noglfog") == 0 {
            shader.fogPass = FP_NONE
            continue
        }
        // polygonOffset
        else if Q_stricmp(token, "polygonOffset") == 0 {
            shader.polygonOffset = true
            continue
        } else if Q_stricmp(token, "noTC") == 0 {
            shader.noTC = true
            continue
        }
        // entityMergable, allowing sprite surfaces from multiple entities
        // to be merged into one batch.  This is a savings for smoke
        // puffs and blood, but can't be used for anything where the
        // shader calcs (not the surface function) reference the entity color or scroll
        else if Q_stricmp(token, "entityMergable") == 0 {
            shader.entityMergable = true
            continue
        }
        // fogParms
        else if Q_stricmp(token, "fogParms") == 0 {
            shader.fogParms = FogParms(Hunk_Alloc(Int32(FogParms.byteCount), h_low))
            if !ParseVector(&text, 3, &shader.fogParms!.color) {
                return false
            }

            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing parm for 'fogParms' keyword in shader '%s'\n", shader.name)
                continue
            }
            shader.fogParms!.depthForOpaque = Float(atof(token))

            // skip any old gradient directions
            SkipRestOfLine(&text)
            continue
        }
        // portal
        else if Q_stricmp(token, "portal") == 0 {
            shader.sort = Float(SS_PORTAL)
            continue
        }
        // skyparms <cloudheight> <outerbox> <innerbox>
        else if Q_stricmp(token, "skyparms") == 0 {
            ParseSkyParms(&text)
            continue
        }
        // light <value> determines flaring in q3map, not needed here
        else if Q_stricmp(token, "light") == 0 {
            token = COM_ParseExt(&text, false)
            continue
        }
        // cull <face>
        else if Q_stricmp(token, "cull") == 0 {
            token = COM_ParseExt(&text, false)
            if token.isEmpty {
                Com_Printf(S_COLOR_YELLOW + "WARNING: missing cull parms in shader '%s'\n", shader.name)
                continue
            }

            if Q_stricmp(token, "none") == 0 || Q_stricmp(token, "twosided") == 0 || Q_stricmp(token, "disable") == 0 {
                shader.cullType = CT_TWO_SIDED
            } else if Q_stricmp(token, "back") == 0 || Q_stricmp(token, "backside") == 0 || Q_stricmp(token, "backsided") == 0 {
                shader.cullType = CT_BACK_SIDED
            } else {
                Com_Printf(S_COLOR_YELLOW + "WARNING: invalid cull parm '%s' in shader '%s'\n", token, shader.name)
            }
            continue
        }
        // sort
        else if Q_stricmp(token, "sort") == 0 {
            ParseSort(&text)
            continue
        } else {
            Com_Printf(S_COLOR_YELLOW + "WARNING: unknown general shader parameter '%s' in '%s'\n", token, shader.name)
            return false
        }
    }

    //
    // ignore shaders that don't have any stages, unless it is a sky or fog
    //
    if s == 0 && shader.sky == nil && (shader.contentFlags & CONTENTS_FOG) == 0 {
        return false
    }

    shader.explicitlyDefined = true

    return true
}

/**
```
================
CollapseMultitexture

Attempt to combine two stages into a single multitexture stage
FIXME: I think modulated add + modulated add collapses incorrectly
=================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2612
private func CollapseMultitexture() -> Bool {
    return false
}

/**
```
==============
SortNewShader

Positions the most recently created shader in the tr.sortedShaders[]
array so that the shader->sort key is sorted reletive to the other
shaders.

Sets shader->sortedIndex
==============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2727
private func SortNewShader() {
    var i: Int32
    var sort: Float
    var newShader: Shader

    newShader = tr.shaders[tr.numShaders - 1]!
    sort = newShader.sort

    i = tr.numShaders - 2
    while i >= 0 {
        if tr.sortedShaders[i]!.sort <= sort {
            break
        }
        tr.sortedShaders[i + 1] = tr.sortedShaders[i]
        tr.sortedShaders[i + 1]!.sortedIndex += 1
        i -= 1
    }

    newShader.sortedIndex = i + 1
    tr.sortedShaders[i + 1] = newShader
}

/**
```
====================
GeneratePermanentShader
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2753
private func GeneratePermanentShader() -> Shader? {
    var newShader: Shader
    var i: Int32
    var b: Int32
    var size: Int32

    if tr.numShaders == MAX_SHADERS {
        //Com_Printf (S_COLOR_YELLOW  "WARNING: GeneratePermanentShader - MAX_SHADERS hit\n");
        Com_Printf("WARNING: GeneratePermanentShader - MAX_SHADERS hit\n")
        return tr.defaultShader
    }

    newShader = Shader(/*ri.*/Hunk_Alloc(Int32(Shader.byteCount), h_low))

    newShader.copy(from: shader)

    if shader.sort <= /*SS_OPAQUE*/SS_SEE_THROUGH {
        newShader.fogPass = FP_EQUAL
    } else if shader.contentFlags & CONTENTS_FOG != 0 {
        newShader.fogPass = FP_LE
    }

    tr.shaders[tr.numShaders] = newShader
    newShader.index = tr.numShaders

    tr.sortedShaders[tr.numShaders] = newShader
    newShader.sortedIndex = tr.numShaders

    tr.numShaders += 1

    size = newShader.numUnfoggedPasses != 0 ? newShader.numUnfoggedPasses * Int32(ShaderStage.byteCount) : Int32(ShaderStage.byteCount)
    newShader.stages = ShaderStage(Hunk_Alloc(size, h_low))

    i = 0
    while i < newShader.numUnfoggedPasses {
        if !stages[i].active {
            break
        }
        newShader.stagesSlots[i].copy(from: stages[i])

        b = 0
        while b < NUM_TEXTURE_BUNDLES {
            if newShader.stagesSlots[i].bundle[b].numTexMods != 0 {
                size = newShader.stagesSlots[i].bundle[b].numTexMods * Int32(TexModInfo.byteCount)
                newShader.stagesSlots[i].bundle[b].texMods = TexModInfo(Hunk_Alloc(size, h_low))
                Com_Memcpy(newShader.stagesSlots[i].bundle[b].texMods!, stages[i].bundle[b].texMods!, size)
            } else {
                newShader.stagesSlots[i].bundle[b].texMods = nil //clear the globabl ptr jic
            }
            b += 1
        }
        i += 1
    }

    SortNewShader()

    let hash = Int32(generateHashValue(newShader.name, FILE_HASH_SIZE))
    newShader.next = hashTable[hash]
    hashTable[hash] = newShader

    return newShader
}

/**
```
=========================
FinishShader

Returns a freshly allocated shader with all the needed info
from the current global working shader
=========================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2941
private func FinishShader() -> Shader? {
    var stage: Int32
    var lmStage: Int32
    var stageIndex: Int32 //rwwRMG - stageIndex for AGEN_BLEND
    var hasLightmapStage: Bool
    var vertexLightmap: Bool

    hasLightmapStage = false
    vertexLightmap = false

    //
    // set sky stuff appropriate
    //
    if shader.sky != nil {
        shader.sort = Float(SS_ENVIRONMENT)
    }

    //
    // set polygon offset
    //
    if shader.polygonOffset && shader.sort == 0 {
        shader.sort = Float(SS_DECAL)
    }

    lmStage = 0
    while lmStage < MAX_SHADER_STAGES {
        let pStage = stages[lmStage]
        if pStage.active && pStage.bundle[0].isLightmap {
            break
        }
        lmStage += 1
    }

    if lmStage < MAX_SHADER_STAGES {
        if shader.lightmapIndex[0] == LIGHTMAP_BY_VERTEX {
            if lmStage == 0 { //< MAX_SHADER_STAGES-1)
                //copy the rest down over the lightmap slot
                memmove(stages.suffix(from: lmStage).bytes, stages.suffix(from: lmStage + 1).bytes, Int32(ShaderStage.byteCount) * (MAX_SHADER_STAGES - lmStage - 1))
                stages[MAX_SHADER_STAGES - 1].clear()
                //change blending on the moved down stage
                // C converts the `int` mask to the `unsigned` field at the store.
                stages[lmStage].stateBits = UInt32(bitPattern: GLS_DEFAULT)
            }
            //change anything that was moved down (or the *white if LM is first) to use vertex color
            stages[lmStage].rgbGen = CGEN_EXACT_VERTEX
            stages[lmStage].alphaGen = AGEN_SKIP
            lmStage = MAX_SHADER_STAGES //skip the style checking below
        }
    }

    if lmStage < MAX_SHADER_STAGES { // && !r_fullbright->value)
        var numStyles: Int32
        var i: Int32

        numStyles = 0
        while numStyles < MAXLIGHTMAPS {
            if shader.styles[numStyles] >= LS_UNUSED {
                break
            }
            numStyles += 1
        }
        numStyles -= 1
        if numStyles > 0 {
            i = MAX_SHADER_STAGES - 1
            while i > lmStage + numStyles {
                stages[i] = stages[i - numStyles]
                i -= 1
            }

            i = 0
            while i < numStyles {
                stages[lmStage + i + 1] = stages[lmStage]
                if shader.lightmapIndex[i + 1] == LIGHTMAP_BY_VERTEX {
                    stages[lmStage + i + 1].bundle[0].image = tr.whiteImage
                } else if shader.lightmapIndex[i + 1] < 0 {
                    Com_Error(ERR_DROP, "FinishShader: light style with no light map or vertex color for shader %s", shader.name)
                } else {
                    stages[lmStage + i + 1].bundle[0].image = tr.lightmaps[shader.lightmapIndex[i + 1]]
                    stages[lmStage + i + 1].bundle[0].tcGen = TCGEN_LIGHTMAP + i + 1
                }
                stages[lmStage + i + 1].rgbGen = CGEN_LIGHTMAPSTYLE
                // C converts the `int` masks to the `unsigned` field at each store.
                stages[lmStage + i + 1].stateBits &= UInt32(bitPattern: ~(GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS))
                stages[lmStage + i + 1].stateBits |= UInt32(bitPattern: GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE)
                i += 1
            }
        }

        i = 0
        while i <= numStyles {
            // C widens the byte to `int` at the store.
            stages[lmStage + i].lightmapStyle = Int32(shader.styles[i])
            i += 1
        }
    }

    //
    // set appropriate stage information
    //
    // The `int` masks meet the `unsigned` `stateBits` in each test of the loop, and the bit pattern of the field gives the bits C tests.
    stageIndex = 0 //rwwRMG - needed for AGEN_BLEND
    stage = 0
    while stage < MAX_SHADER_STAGES {
        let pStage = stages[stage]

        if !pStage.active {
            break
        }

        // check for a missing texture
        if pStage.bundle[0].image == nil {
            Com_Printf(S_COLOR_YELLOW + "Shader %s has a stage with no image\n", shader.name)
            pStage.active = false
            stage += 1
            continue
        }

        //
        // ditch this stage if it's detail and detail textures are disabled
        //
        if pStage.isDetail && r_detailTextures!.integer == 0 {
            if stage < (MAX_SHADER_STAGES - 1) {
                memmove(stages.suffix(from: stage).bytes, stages.suffix(from: stage + 1).bytes, Int32(ShaderStage.byteCount) * (MAX_SHADER_STAGES - stage - 1))

                // rww - 9-13-01 [1-26-01-sof2]
                stages[stage + (MAX_SHADER_STAGES - stage - 1)].clear() //clear the last one moved down
                stage -= 1 //look at this stage next time around
            }
            stage += 1
            continue
        }

        pStage.index = stageIndex //rwwRMG - needed for AGEN_BLEND

        //
        // default texture coordinate generation
        //
        if pStage.bundle[0].isLightmap {
            if pStage.bundle[0].tcGen == TCGEN_BAD {
                pStage.bundle[0].tcGen = TCGEN_LIGHTMAP
            }
            hasLightmapStage = true
        } else {
            if pStage.bundle[0].tcGen == TCGEN_BAD {
                pStage.bundle[0].tcGen = TCGEN_TEXTURE
            }
        }

        // not a true lightmap but we want to leave existing
        // behaviour in place and not print out a warning
        //if (pStage->rgbGen == CGEN_VERTEX) {
        //  vertexLightmap = qtrue;
        //}

        //
        // determine sort order and fog color adjustment
        //
        if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) != 0 &&
            (Int32(bitPattern: stages[0].stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) != 0
        {
            let blendSrcBits = Int32(bitPattern: pStage.stateBits) & GLS_SRCBLEND_BITS
            let blendDstBits = Int32(bitPattern: pStage.stateBits) & GLS_DSTBLEND_BITS

            // fog color adjustment only works for blend modes that have a contribution
            // that aproaches 0 as the modulate values aproach 0 --
            // GL_ONE, GL_ONE
            // GL_ZERO, GL_ONE_MINUS_SRC_COLOR
            // GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA

            // modulate, additive
            if ((blendSrcBits == GLS_SRCBLEND_ONE) && (blendDstBits == GLS_DSTBLEND_ONE)) ||
                ((blendSrcBits == GLS_SRCBLEND_ZERO) && (blendDstBits == GLS_DSTBLEND_ONE_MINUS_SRC_COLOR))
            {
                pStage.adjustColorsForFog = ACFF_MODULATE_RGB
            }
            // strict blend
            else if (blendSrcBits == GLS_SRCBLEND_SRC_ALPHA) && (blendDstBits == GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA) {
                pStage.adjustColorsForFog = ACFF_MODULATE_ALPHA
            }
            // premultiplied alpha
            else if (blendSrcBits == GLS_SRCBLEND_ONE) && (blendDstBits == GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA) {
                pStage.adjustColorsForFog = ACFF_MODULATE_RGBA
            } else {
                // we can't adjust this one correctly, so it won't be exactly correct in fog
            }

            // don't screw with sort order if this is a portal or environment
            if shader.sort == 0 {
                // see through item, like a grill or grate
                if (Int32(bitPattern: pStage.stateBits) & GLS_DEPTHMASK_TRUE) != 0 {
                    shader.sort = Float(SS_SEE_THROUGH)
                } else {
                    /*
                    if (( blendSrcBits == GLS_SRCBLEND_ONE ) && ( blendDstBits == GLS_DSTBLEND_ONE ))
                    {
                    	// GL_ONE GL_ONE needs to come a bit later
                    	shader.sort = SS_BLEND2;
                    }
                    else if (( blendSrcBits == GLS_SRCBLEND_SRC_ALPHA ) && ( blendDstBits == GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA ))
                    { //rww - Pushed SS_BLEND1 up to SS_BLEND2, inserting this so that saber glow will render above water and things.
                      //Unfortunately it still affects other shaders with the same blend settings, but it seems more or less alright.
                    	shader.sort = SS_BLEND1;
                    }
                    else
                    {
                    	shader.sort = SS_BLEND0;
                    }
                    */
                    if (blendSrcBits == GLS_SRCBLEND_ONE) && (blendDstBits == GLS_DSTBLEND_ONE) {
                        // GL_ONE GL_ONE needs to come a bit later
                        shader.sort = Float(SS_BLEND1)
                    } else {
                        shader.sort = Float(SS_BLEND0)
                    }
                }
            }
        }

        //rww - begin hw fog
        if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE) {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_BLACK
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_SRC_ALPHA | GLS_DSTBLEND_ONE) &&
            pStage.alphaGen == AGEN_LIGHTING_SPECULAR && stage != 0
        {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_BLACK
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_ZERO | GLS_DSTBLEND_ZERO) {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_WHITE
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_ONE | GLS_DSTBLEND_ZERO) {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_WHITE
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == 0 && stage != 0 {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_WHITE
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == 0 && pStage.bundle[0].isLightmap && stage < MAX_SHADER_STAGES - 1 &&
            stages[stage + 1].bundle[0].isLightmap
        { // multiple light map blending
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_WHITE
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO) && pStage.bundle[0].isLightmap { //I don't know, it works. -rww
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_WHITE
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO) { //I don't know, it works. -rww
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_BLACK
        } else if (Int32(bitPattern: pStage.stateBits) & (GLS_SRCBLEND_BITS | GLS_DSTBLEND_BITS)) == (GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE_MINUS_SRC_COLOR) { //I don't know, it works. -rww
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_BLACK
        } else {
            pStage.mGLFogColorOverride = GLFOGOVERRIDE_NONE
        }
        //rww - end hw fog

        stageIndex += 1 //rwwRMG - needed for AGEN_BLEND
        stage += 1
    }

    // there are times when you will need to manually apply a sort to
    // opaque alpha tested shaders that have later blend passes
    if shader.sort == 0 {
        shader.sort = Float(SS_OPAQUE)
    }

    //
    // if we are in r_vertexLight mode, never use a lightmap texture
    //
    if stage > 1 && (r_vertexLight!.integer != 0 && r_uiFullScreen!.integer == 0) {
        //stage = VertexLightingCollapse();
        //rww - since this does bad things, I am commenting it out for now. If you want to attempt a fix, feel free.
        hasLightmapStage = false
    }

    //
    // look for multitexture potential
    //
    if stage > 1 && CollapseMultitexture() {
        stage -= 1
    }

    if shader.lightmapIndex[0] >= 0 && !hasLightmapStage {
        if vertexLightmap {
            //			ri.DPrintf( "WARNING: shader '%s' has VERTEX forced lightmap!\n", shader.name );
        } else {
            Com_Printf("WARNING: shader '%s' has lightmap but no lightmap stage!\n", shader.name)
            // AI: Raven copies the table with memcpy. The table is a Swift array, so the loop copies each index into the record.
            for i in 0..<shader.lightmapIndex.count {
                shader.lightmapIndex[i] = lightmapsNone[i]
            }
            // AI: Raven copies the styles with memcpy. The list is a Swift array, so the loop copies each index into the record.
            for i in 0..<shader.styles.count {
                shader.styles[i] = stylesDefault[i]
            }
        }
    }

    //
    // compute number of passes
    //
    shader.numUnfoggedPasses = stage

    // fogonly shaders don't have any normal passes
    if stage == 0 {
        shader.sort = Float(SS_FOG)
    }

    stage = 1
    while stage < shader.numUnfoggedPasses {
        // Make sure stage is non detail and active
        if stages[stage].isDetail || !stages[stage].active {
            break
        }
        // MT lightmaps are always in bundle 1
        if stages[stage].bundle[0].isLightmap {
            stage += 1
            continue
        }
        stage += 1
    }

    return GeneratePermanentShader()
}

/**
```
====================
FindShaderInShaderText

Scans the combined text description of all the shader files for
the given shader name.

return NULL if not found

If found, it will return a valid shader
=====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3291
private func FindShaderInShaderText(_ shadername: String) -> String? {
    var token: String
    var p: TextCursor

    var i: Int32
    var hash: Int32

    hash = Int32(generateHashValue(shadername, MAX_SHADERTEXT_HASH))

    // AI: Raven walks the NULL-terminated list of hash `hash`. The walk reads each cursor of the list.
    i = 0
    while i < shaderTextHashTable[hash].count {
        p = shaderTextHashTable[hash][i]
        token = COM_ParseExt(&p, true)
        if Q_stricmp(token, shadername) == 0 {
            return p.text
        }
        i += 1
    }

    // AI: Raven tests the NULL pointer `s_shaderText`. The dedicated build never sets the text, and the empty String stands for NULL.
    if s_shaderText.isEmpty {
        return nil
    }
    p = TextCursor(CharBuf(s_shaderText))

    // look for label
    while 1 != 0 {
        token = COM_ParseExt(&p, true)
        if token.isEmpty {
            break
        }

        if Q_stricmp(token, shadername) == 0 {
            return p.text
        } else {
            // skip the definition
            SkipBracedSection(&p)
        }
    }

    return nil
}

/**
```
==================
R_FindShaderByName

Will always return a valid shader, but it might be the
default shader if the real one can't be found.
==================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3342
func R_FindShaderByName(_ name: String) -> Shader? {
    var strippedName = CharBuf(MAX_QPATH)
    var hash: Int32
    var sh: Shader?

    if name.isEmpty { // bk001205
        return tr.defaultShader
    }

    COM_StripExtension(name, &strippedName)

    hash = Int32(generateHashValue(String(strippedName), FILE_HASH_SIZE))

    //
    // see if the shader is already loaded
    //
    sh = hashTable[hash]
    while let s = sh {
        // NOTE: if there was no shader or image available with the name strippedName
        // then a default shader is created with lightmapIndex == LIGHTMAP_NONE, so we
        // have to check all default shaders otherwise for every call to R_FindShader
        // with that same strippedName a new default shader is created.
        if Q_stricmp(s.name, String(strippedName)) == 0 {
            // match found
            return s
        }
        sh = s.next
    }

    return tr.defaultShader
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3373
func IsShader(_ sh: Shader, _ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte]) -> Bool {
    var i: Int32

    if Q_stricmp(sh.name, name) != 0 {
        return false
    }

    if !sh.defaultShader {
        i = 0
        while i < MAXLIGHTMAPS {
            if sh.lightmapIndex[i] != lightmapIndex![i] {
                return false
            }
            if sh.styles[i] != styles[i] {
                return false
            }
            i += 1
        }
    }

    return true
}

/**
```
===============
R_FindShader

Will always return a valid shader, but it might be the
default shader if the real one can't be found.

In the interest of not requiring an explicit shader text entry to
be defined for every single image used in the game, three default
shader behaviors can be auto-created for any image:

If lightmapIndex == LIGHTMAP_NONE, then the image will have
dynamic diffuse lighting applied to it, as apropriate for most
entity skin surfaces.

If lightmapIndex == LIGHTMAP_2D, then the image will be used
for 2D rendering unless an explicit shader is found

If lightmapIndex == LIGHTMAP_BY_VERTEX, then the image will use
the vertex rgba modulate values, as apropriate for misc_model
pre-lit surfaces.

Other lightmapIndex values will have a lightmap stage created
and src*dest blending applied with the texture, as apropriate for
most world construction surfaces.

===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3428
func R_FindShader(_ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte], _ mipRawImage: Bool) -> Shader? {
    var strippedName = CharBuf(MAX_QPATH)
    var hash: Int32
    var sh: Shader?
    var lightmapIndex = lightmapIndex
    var fileName = CharBuf(MAX_QPATH)
    var shaderText: String?

    if name.isEmpty {
        return tr.defaultShader
    }

    // use (fullbright) vertex lighting if the bsp file doesn't have
    // lightmaps
    if lightmapIndex![0] >= 0 && lightmapIndex![0] >= tr.numLightmaps {
        lightmapIndex = lightmapsVertex
    }

    COM_StripExtension(name, &strippedName)

    hash = Int32(generateHashValue(String(strippedName), FILE_HASH_SIZE))

    //
    // see if the shader is already loaded
    //
    sh = hashTable[hash]
    while let s = sh {
        // NOTE: if there was no shader or image available with the name strippedName
        // then a default shader is created with lightmapIndex == LIGHTMAP_NONE, so we
        // have to check all default shaders otherwise for every call to R_FindShader
        // with that same strippedName a new default shader is created.
        if IsShader(s, String(strippedName), lightmapIndex, styles) {
            return s
        }
        sh = s.next
    }

    // clear the global shader
    ClearGlobalShader()
    Q_strncpyz(&shader.nameBuffer, String(strippedName), Int32(shader.nameBuffer.count))
    // AI: Raven copies the table with memcpy. The table is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.lightmapIndex.count {
        shader.lightmapIndex[i] = lightmapIndex![i]
    }
    // AI: Raven copies the styles with memcpy. The list is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.styles.count {
        shader.styles[i] = styles[i]
    }

    //
    // attempt to define shader from an explicit parameter file
    //
    shaderText = FindShaderInShaderText(String(strippedName))
    if shaderText != nil {
        var text = TextCursor(CharBuf(shaderText!))
        if !ParseShader(&text) {
            // had errors, so use default shader
            shader.defaultShader = true
        }
        sh = FinishShader()
        return sh
    }

    //
    // if not defined in the in-memory shader descriptions,
    // look for a single TGA, BMP, or PCX
    //
    COM_StripExtension(name, &fileName)
    shader.defaultShader = true
    return FinishShader()
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3560
func R_FindServerShader(_ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte], _ mipRawImage: Bool) -> Shader? {
    var strippedName = CharBuf(MAX_QPATH)
    var hash: Int32
    var sh: Shader?

    if name.isEmpty {
        return tr.defaultShader
    }

    COM_StripExtension(name, &strippedName)

    hash = Int32(generateHashValue(String(strippedName), FILE_HASH_SIZE))

    //
    // see if the shader is already loaded
    //
    sh = hashTable[hash]
    while let s = sh {
        // NOTE: if there was no shader or image available with the name strippedName
        // then a default shader is created with lightmapIndex == LIGHTMAP_NONE, so we
        // have to check all default shaders otherwise for every call to R_FindShader
        // with that same strippedName a new default shader is created.
        if IsShader(s, String(strippedName), lightmapIndex, styles) {
            return s
        }
        sh = s.next
    }

    // clear the global shader
    ClearGlobalShader()
    Q_strncpyz(&shader.nameBuffer, String(strippedName), Int32(shader.nameBuffer.count))
    // AI: Raven copies the table with memcpy. The table is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.lightmapIndex.count {
        shader.lightmapIndex[i] = lightmapIndex![i]
    }
    // AI: Raven copies the styles with memcpy. The list is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.styles.count {
        shader.styles[i] = styles[i]
    }

    shader.defaultShader = true
    return FinishShader()
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3598
func RE_RegisterShaderFromImage(_ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte], _ image: Image, _ mipRawImage: Bool) -> JKAShared.qhandle_t {
    // No file of the oracle calls it, and tr_local.h:1775 only declares it, so the function is dead.
    var i: Int32
    let hash: Int32
    var sh: Shader?

    hash = Int32(generateHashValue(name, FILE_HASH_SIZE))

    //
    // see if the shader is already loaded
    //
    sh = hashTable[hash]
    while let s = sh {
        // NOTE: if there was no shader or image available with the name strippedName
        // then a default shader is created with lightmapIndex == LIGHTMAP_NONE, so we
        // have to check all default shaders otherwise for every call to R_FindShader
        // with that same strippedName a new default shader is created.
        if IsShader(s, name, lightmapIndex, styles) {
            return s.index
        }
        sh = s.next
    }

    // clear the global shader
    shader.clear()
    stages.zero()
    Q_strncpyz(&shader.nameBuffer, name, Int32(shader.nameBuffer.count))
    // AI: Raven copies the table with memcpy. The table is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.lightmapIndex.count {
        shader.lightmapIndex[i] = lightmapIndex![i]
    }
    // AI: Raven copies the styles with memcpy. The list is a Swift array, so the loop copies each index into the record.
    for i in 0..<shader.styles.count {
        shader.styles[i] = styles[i]
    }

    i = 0
    while i < MAX_SHADER_STAGES {
        // Raven's row `texMods[i]` of the two-dimensional table starts at record `i * TR_MAX_TEXMODS` of the flat storage.
        stages[i].bundle[0].texModsSlots = texMods.suffix(from: i * TR_MAX_TEXMODS)
        i += 1
    }

    //
    // create the default shading commands
    //
    // C converts the `int` masks to the `unsigned` field at each store.
    if shader.lightmapIndex[0] == LIGHTMAP_NONE {
        // dynamic colors at vertexes
        stages[0].bundle[0].image = image
        stages[0].active = true
        stages[0].rgbGen = CGEN_LIGHTING_DIFFUSE
        stages[0].stateBits = UInt32(bitPattern: GLS_DEFAULT)
    } else if shader.lightmapIndex[0] == LIGHTMAP_BY_VERTEX {
        // explicit colors at vertexes
        stages[0].bundle[0].image = image
        stages[0].active = true
        stages[0].rgbGen = CGEN_EXACT_VERTEX
        stages[0].alphaGen = AGEN_SKIP
        stages[0].stateBits = UInt32(bitPattern: GLS_DEFAULT)
    } else if shader.lightmapIndex[0] == LIGHTMAP_2D {
        // GUI elements
        stages[0].bundle[0].image = image
        stages[0].active = true
        stages[0].rgbGen = CGEN_VERTEX
        stages[0].alphaGen = AGEN_VERTEX
        stages[0].stateBits = UInt32(bitPattern: GLS_DEPTHTEST_DISABLE |
            GLS_SRCBLEND_SRC_ALPHA |
            GLS_DSTBLEND_ONE_MINUS_SRC_ALPHA)
    } else if shader.lightmapIndex[0] == LIGHTMAP_WHITEIMAGE {
        // fullbright level
        stages[0].bundle[0].image = tr.whiteImage
        stages[0].active = true
        stages[0].rgbGen = CGEN_IDENTITY_LIGHTING
        stages[0].stateBits = UInt32(bitPattern: GLS_DEFAULT)

        stages[1].bundle[0].image = image
        stages[1].active = true
        stages[1].rgbGen = CGEN_IDENTITY
        stages[1].stateBits |= UInt32(bitPattern: GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO)
    } else {
        // two pass lightmap
        stages[0].bundle[0].image = tr.lightmaps[shader.lightmapIndex[0]]
        stages[0].bundle[0].isLightmap = true
        stages[0].active = true
        stages[0].rgbGen = CGEN_IDENTITY // lightmaps are scaled on creation
        // for identitylight
        stages[0].stateBits = UInt32(bitPattern: GLS_DEFAULT)

        stages[1].bundle[0].image = image
        stages[1].active = true
        stages[1].rgbGen = CGEN_IDENTITY
        stages[1].stateBits |= UInt32(bitPattern: GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO)
    }

    sh = FinishShader()
    return sh!.index
}

/**
```
====================
RE_RegisterShader

This is the exported shader entry point for the rest of the system
It will always return an index that will be valid.

This should really only be used for explicit shaders, because there is no
way to ask for different implicit lighting modes (vertex, lightmap, etc)
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3696
func RE_RegisterShaderLightMap(_ name: String, _ lightmapIndex: [Int32]?, _ styles: [JKAShared.byte]) -> JKAShared.qhandle_t {
    var sh: Shader?

    if strlen(name) >= MAX_QPATH {
        Com_Printf("Shader name exceeds MAX_QPATH\n")
        return 0
    }

    sh = R_FindShader(name, lightmapIndex, styles, true)

    // we want to return 0 if the shader failed to
    // load for some reason, but R_FindShader should
    // still keep a name allocated for it, so if
    // something calls RE_RegisterShader again with
    // the same name, we don't try looking for it again
    if sh!.defaultShader {
        return 0
    }

    return sh!.index
}

/**
```
====================
RE_RegisterShader

This is the exported shader entry point for the rest of the system
It will always return an index that will be valid.

This should really only be used for explicit shaders, because there is no
way to ask for different implicit lighting modes (vertex, lightmap, etc)
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3731
func RE_RegisterShader(_ name: String) -> JKAShared.qhandle_t {
    if strlen(name) >= MAX_QPATH {
        Com_Printf("Shader name exceeds MAX_QPATH\n")
        return 0
    }

    let sh = R_FindShader(name, lightmaps2d, stylesDefault, true)

    // we want to return 0 if the shader failed to
    // load for some reason, but R_FindShader should
    // still keep a name allocated for it, so if
    // something calls RE_RegisterShader again with
    // the same name, we don't try looking for it again
    if sh!.defaultShader {
        return 0
    }

    return sh!.index
}

/**
```
====================
RE_RegisterShaderNoMip

For menu graphics that should never be picmiped
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3761
func RE_RegisterShaderNoMip(_ name: String) -> JKAShared.qhandle_t {
    if strlen(name) >= MAX_QPATH {
        Com_Printf("Shader name exceeds MAX_QPATH\n")
        return 0
    }

    let sh = R_FindShader(name, lightmaps2d, stylesDefault, false)

    // we want to return 0 if the shader failed to
    // load for some reason, but R_FindShader should
    // still keep a name allocated for it, so if
    // something calls RE_RegisterShader again with
    // the same name, we don't try looking for it again
    if sh!.defaultShader {
        return 0
    }

    return sh!.index
}

//added for ui -rww
/// Source: oracle/codemp/renderer/tr_shader.cpp:3785
func RE_ShaderNameFromIndex(_ index: Int32) -> String {
    assert(index >= 0 && index < tr.numShaders && tr.shaders[index] != nil)
    return tr.shaders[index]!.name
}

/**
```
====================
R_GetShaderByHandle

When a handle is passed in by another module, this range checks
it and returns a valid (possibly default) shader_t to be used internally.
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:3800
func R_GetShaderByHandle(_ hShader: JKAShared.qhandle_t) -> Shader? {
    if hShader < 0 {
        Com_Printf(S_COLOR_YELLOW + "R_GetShaderByHandle: out of range hShader '%d'\n", hShader) // bk: FIXME name
        return tr.defaultShader
    }
    if hShader >= tr.numShaders {
        Com_Printf(S_COLOR_YELLOW + "R_GetShaderByHandle: out of range hShader '%d'\n", hShader)
        return tr.defaultShader
    }
    return tr.shaders[hShader]
}

/**
```
==================
R_InitShaders
==================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:4265
func R_InitShaders(_ server: Bool) {
    //Com_Printf ("Initializing Shaders\n" );

    hashTable.fill(nil)

    deferLoad = false
}
