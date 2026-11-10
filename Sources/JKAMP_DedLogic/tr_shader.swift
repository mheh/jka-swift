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
func R_RemapShader(_ shaderName: String, _ newShaderName: String, _ timeOffset: String) {
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
    sh2!.timeOffset = Float(atof(timeOffset))
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
private func ParseSurfaceSprites(_ _text: String, _ stage: ShaderStage) {
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
private func ParseSurfaceSpritesOptional(_ param: String, _ _text: String, _ stage: ShaderStage) {
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
private func ParseStage(_ stage: ShaderStage, _ text: inout JKAShared.TextCursor) -> Bool {
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
