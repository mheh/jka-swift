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
// TODO: Port global stages
// Raven wrote: static shaderStage_t stages[MAX_SHADER_STAGES]
// No view for `shaderStage_t` of `tr_local.h`.

/// Source: oracle/codemp/renderer/tr_shader.cpp:101
// TODO: Port global shader
// Raven wrote: static shader_t shader
// No view for `shader_s` of `tr_local.h`.

/// Source: oracle/codemp/renderer/tr_shader.cpp:102
// TODO: Port global texMods
// Raven wrote: static texModInfo_t texMods[MAX_SHADER_STAGES][TR_MAX_TEXMODS]
// No view for `texModInfo_t` of `tr_local.h`.

/// Source: oracle/codemp/renderer/tr_shader.cpp:103
var deferLoad: Bool {
    get { world.variables.deferLoad }
    set { world.variables.deferLoad = newValue }
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:105
private let FILE_HASH_SIZE = 1024 as Int32

/// Source: oracle/codemp/renderer/tr_shader.cpp:106
// TODO: Port global hashTable
// Raven wrote: static shader_t* hashTable[FILE_HASH_SIZE]
// No table row for `shader_t *[1024]`.

/// Source: oracle/codemp/renderer/tr_shader.cpp:108
let MAX_SHADERTEXT_HASH = 2048 as Int32

/// Source: oracle/codemp/renderer/tr_shader.cpp:109
// TODO: Port global shaderTextHashTable
// Raven wrote: static char **shaderTextHashTable[MAX_SHADERTEXT_HASH] = { 0 }
// No table row for `char **[2048]`.

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
// AI: Raven fills the table with LIGHTMAP_BY_VERTEX of tr_local.h:432, which has no re-export in the host target. The table holds its value, -3.
let lightmapsVertex: [Int32] = [
    -3,
    -3,
    -3,
    -3,
]

/// Source: oracle/codemp/renderer/tr_shader.cpp:149
// Raven wrote: const int lightmapsFullBright[MAXLIGHTMAPS]
// AI: Raven fills the table with LIGHTMAP_WHITEIMAGE of tr_local.h:433, which has no re-export in the host target. The table holds its value, -2.
let lightmapsFullBright: [Int32] = [
    -2,
    -2,
    -2,
    -2,
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

/// Source: oracle/codemp/renderer/tr_shader.cpp:2228
// TODO: Port global infoParms
// Raven wrote: infoParm_t infoParms[]
// No view for `infoParm_t`, a struct Raven defines inside a .c file.

/// Source: oracle/codemp/renderer/tr_shader.cpp:111
func KillTheShaderHashTable() {
    // Port-note: Row TR7. `shaderTextHashTable`, the `char **[MAX_SHADERTEXT_HASH]` of tr_shader.cpp:109, has no table row.
    // TODO: Port KillTheShaderHashTable
    portMissing("KillTheShaderHashTable", source: "oracle/codemp/renderer/tr_shader.cpp:111")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:116
func ShaderHashTableExists() -> Bool {
    // Port-note: Row TR7. `shaderTextHashTable`, the `char **[MAX_SHADERTEXT_HASH]` of tr_shader.cpp:109, has no table row.
    // TODO: Port ShaderHashTableExists
    portMissing("ShaderHashTableExists", source: "oracle/codemp/renderer/tr_shader.cpp:116")
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
func R_CreateExtendedName(_ extendedName: inout JKAShared.CharBuf, _ name: String, _ lightmapIndex: Int32, _ styles: Slots<UInt8>) {
    // Port-note: Row TR8. The signature takes `Int32` for `const int *lightmapIndex`, and Raven indexes the pointer and compares it with the four lightmap tables.
    // TODO: Port R_CreateExtendedName
    portMissing("R_CreateExtendedName", source: "oracle/codemp/renderer/tr_shader.cpp:177")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:234
private func ClearGlobalShader() {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ClearGlobalShader
    portMissing("ClearGlobalShader", source: "oracle/codemp/renderer/tr_shader.cpp:234")
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
func R_RemapShader(_ shaderName: String, _ newShaderName: String, _ timeOffset: String) {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_RemapShader
    portMissing("R_RemapShader", source: "oracle/codemp/renderer/tr_shader.cpp:273")
}

/**
```
===============
ParseVector
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:323
func ParseVector(_ text: inout JKAShared.TextCursor, _ count: Int32, _ v: Slots<Float>) -> Bool {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseVector
    portMissing("ParseVector", source: "oracle/codemp/renderer/tr_shader.cpp:323")
}

/**
```
===============
NameToAFunc
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:358
private func NameToAFunc(_ funcname: String) -> UInt32 {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port NameToAFunc
    portMissing("NameToAFunc", source: "oracle/codemp/renderer/tr_shader.cpp:358")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port NameToSrcBlendMode
    portMissing("NameToSrcBlendMode", source: "oracle/codemp/renderer/tr_shader.cpp:387")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port NameToDstBlendMode
    portMissing("NameToDstBlendMode", source: "oracle/codemp/renderer/tr_shader.cpp:435")
}

/**
```
===============
NameToGenFunc
===============
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:479
// TODO: Port signature
// Raven wrote: static genFunc_t NameToGenFunc( const char *funcname )
// No table row for the return `genFunc_t`.
private func NameToGenFunc() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port NameToGenFunc
    portMissing("NameToGenFunc", source: "oracle/codemp/renderer/tr_shader.cpp:479")
}

/**
```
===================
ParseWaveForm
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:520
// TODO: Port signature
// Raven wrote: static void ParseWaveForm( const char **text, waveForm_t *wave )
// No table row for `waveForm_t * wave`.
private func ParseWaveForm() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseWaveForm
    portMissing("ParseWaveForm", source: "oracle/codemp/renderer/tr_shader.cpp:520")
}

/**
```
===================
ParseTexMod
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:572
// TODO: Port signature
// Raven wrote: static void ParseTexMod( const char *_text, shaderStage_t *stage )
// No table row for `shaderStage_t * stage`.
private func ParseTexMod() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseTexMod
    portMissing("ParseTexMod", source: "oracle/codemp/renderer/tr_shader.cpp:572")
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
// TODO: Port signature
// Raven wrote: static void ParseSurfaceSprites( const char *_text, shaderStage_t *stage )
// No table row for `shaderStage_t * stage`.
private func ParseSurfaceSprites() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseSurfaceSprites
    portMissing("ParseSurfaceSprites", source: "oracle/codemp/renderer/tr_shader.cpp:808")
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
// TODO: Port signature
// Raven wrote: static void ParseSurfaceSpritesOptional( const char *param, const char *_text, shaderStage_t *stage )
// No table row for `shaderStage_t * stage`.
private func ParseSurfaceSpritesOptional() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseSurfaceSpritesOptional
    portMissing("ParseSurfaceSpritesOptional", source: "oracle/codemp/renderer/tr_shader.cpp:970")
}

/**
```
===================
ParseStage
===================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:1279
// TODO: Port signature
// Raven wrote: static qboolean ParseStage( shaderStage_t *stage, const char **text )
// No table row for `shaderStage_t * stage`.
private func ParseStage() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseStage
    portMissing("ParseStage", source: "oracle/codemp/renderer/tr_shader.cpp:1279")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseDeform
    portMissing("ParseDeform", source: "oracle/codemp/renderer/tr_shader.cpp:1936")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseSkyParms
    portMissing("ParseSkyParms", source: "oracle/codemp/renderer/tr_shader.cpp:2086")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseSort
    portMissing("ParseSort", source: "oracle/codemp/renderer/tr_shader.cpp:2145")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:2198
func ParseMaterial(_ text: inout JKAShared.TextCursor) {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseMaterial
    portMissing("ParseMaterial", source: "oracle/codemp/renderer/tr_shader.cpp:2198")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseSurfaceParm
    portMissing("ParseSurfaceParm", source: "oracle/codemp/renderer/tr_shader.cpp:2275")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port ParseShader
    portMissing("ParseShader", source: "oracle/codemp/renderer/tr_shader.cpp:2300")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port CollapseMultitexture
    portMissing("CollapseMultitexture", source: "oracle/codemp/renderer/tr_shader.cpp:2612")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port SortNewShader
    portMissing("SortNewShader", source: "oracle/codemp/renderer/tr_shader.cpp:2727")
}

/**
```
====================
GeneratePermanentShader
====================
```
*/
/// Source: oracle/codemp/renderer/tr_shader.cpp:2753
// TODO: Port signature
// Raven wrote: static shader_t *GeneratePermanentShader( void )
// No table row for the return `shader_t *`.
private func GeneratePermanentShader() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port GeneratePermanentShader
    portMissing("GeneratePermanentShader", source: "oracle/codemp/renderer/tr_shader.cpp:2753")
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
// TODO: Port signature
// Raven wrote: static shader_t *FinishShader( void )
// No table row for the return `shader_t *`.
private func FinishShader() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port FinishShader
    portMissing("FinishShader", source: "oracle/codemp/renderer/tr_shader.cpp:2941")
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
    // Port-note: Row TR7. `shaderTextHashTable`, the `char **[MAX_SHADERTEXT_HASH]` of tr_shader.cpp:109, has no table row.
    // TODO: Port FindShaderInShaderText
    portMissing("FindShaderInShaderText", source: "oracle/codemp/renderer/tr_shader.cpp:3291")
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
// TODO: Port signature
// Raven wrote: shader_t *R_FindShaderByName( const char *name )
// No table row for the return `shader_t *`.
func R_FindShaderByName() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_FindShaderByName
    portMissing("R_FindShaderByName", source: "oracle/codemp/renderer/tr_shader.cpp:3342")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3373
// TODO: Port signature
// Raven wrote: inline qboolean IsShader(shader_t *sh, const char *name, const int *lightmapIndex, const byte *styles)
// No table row for `shader_t * sh`.
func IsShader() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port IsShader
    portMissing("IsShader", source: "oracle/codemp/renderer/tr_shader.cpp:3373")
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
// TODO: Port signature
// Raven wrote: shader_t *R_FindShader( const char *name, const int *lightmapIndex, const byte *styles, qboolean mipRawImage )
// No table row for the return `shader_t *`.
func R_FindShader() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_FindShader
    portMissing("R_FindShader", source: "oracle/codemp/renderer/tr_shader.cpp:3428")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3560
// TODO: Port signature
// Raven wrote: shader_t *R_FindServerShader( const char *name, const int *lightmapIndex, const byte *styles, qboolean mipRawImage )
// No table row for the return `shader_t *`.
func R_FindServerShader() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_FindServerShader
    portMissing("R_FindServerShader", source: "oracle/codemp/renderer/tr_shader.cpp:3560")
}

/// Source: oracle/codemp/renderer/tr_shader.cpp:3598
// TODO: Port signature
// Raven wrote: qhandle_t RE_RegisterShaderFromImage(const char *name, int *lightmapIndex, byte *styles, image_t *image, qboolean mipRawImage)
// No table row for `image_t * image`.
func RE_RegisterShaderFromImage() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterShaderFromImage
    portMissing("RE_RegisterShaderFromImage", source: "oracle/codemp/renderer/tr_shader.cpp:3598")
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
func RE_RegisterShaderLightMap(_ name: String, _ lightmapIndex: Int32, _ styles: Slots<UInt8>) -> JKAShared.qhandle_t {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterShaderLightMap
    portMissing("RE_RegisterShaderLightMap", source: "oracle/codemp/renderer/tr_shader.cpp:3696")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterShader
    portMissing("RE_RegisterShader", source: "oracle/codemp/renderer/tr_shader.cpp:3731")
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
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_RegisterShaderNoMip
    portMissing("RE_RegisterShaderNoMip", source: "oracle/codemp/renderer/tr_shader.cpp:3761")
}

//added for ui -rww
/// Source: oracle/codemp/renderer/tr_shader.cpp:3785
func RE_ShaderNameFromIndex(_ index: Int32) -> String {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port RE_ShaderNameFromIndex
    portMissing("RE_ShaderNameFromIndex", source: "oracle/codemp/renderer/tr_shader.cpp:3785")
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
// TODO: Port signature
// Raven wrote: shader_t *R_GetShaderByHandle( qhandle_t hShader )
// No table row for the return `shader_t *`.
func R_GetShaderByHandle() -> Never {
    // Port-note: Row TR1. The renderer records of tr_local.h, `trGlobals_t` and the rest, have no C header and no view in the host target, so `tr` and the records the body reads have no Swift name.
    // TODO: Port R_GetShaderByHandle
    portMissing("R_GetShaderByHandle", source: "oracle/codemp/renderer/tr_shader.cpp:3800")
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

    // Port-note: Row TR1. `hashTable`, the `shader_t *` table of tr_shader.cpp:106, has no storage row, because `shader_t` has no view in the host target.
    // Raven wrote: Com_Memset(hashTable, 0, sizeof(hashTable))
    portMissing("R_InitShaders", source: "oracle/codemp/renderer/tr_shader.cpp:4269")

    deferLoad = false
}
