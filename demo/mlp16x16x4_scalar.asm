hidden_0:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 68]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 72]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 76]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 80]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 84]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 88]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 92]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 96]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 100]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 104]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 108]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 112]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 116]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 120]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 124]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 128]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_0_store_zero
VSTORE [v0 + 1092], v1
VCMPEQ p0, v0, v0
BRA hidden_0_done
hidden_0_store_zero:
VSTORE [v0 + 1092], v0
hidden_0_done:
hidden_1:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 132]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 136]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 140]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 144]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 148]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 152]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 156]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 160]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 164]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 168]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 172]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 176]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 180]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 184]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 188]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 192]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_1_store_zero
VSTORE [v0 + 1096], v1
VCMPEQ p0, v0, v0
BRA hidden_1_done
hidden_1_store_zero:
VSTORE [v0 + 1096], v0
hidden_1_done:
hidden_2:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 196]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 200]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 204]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 208]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 212]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 216]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 220]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 224]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 228]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 232]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 236]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 240]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 244]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 248]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 252]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 256]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_2_store_zero
VSTORE [v0 + 1100], v1
VCMPEQ p0, v0, v0
BRA hidden_2_done
hidden_2_store_zero:
VSTORE [v0 + 1100], v0
hidden_2_done:
hidden_3:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 260]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 264]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 268]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 272]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 276]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 280]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 284]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 288]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 292]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 296]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 300]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 304]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 308]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 312]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 316]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 320]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_3_store_zero
VSTORE [v0 + 1104], v1
VCMPEQ p0, v0, v0
BRA hidden_3_done
hidden_3_store_zero:
VSTORE [v0 + 1104], v0
hidden_3_done:
hidden_4:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 324]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 328]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 332]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 336]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 340]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 344]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 348]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 352]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 356]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 360]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 364]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 368]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 372]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 376]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 380]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 384]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_4_store_zero
VSTORE [v0 + 1108], v1
VCMPEQ p0, v0, v0
BRA hidden_4_done
hidden_4_store_zero:
VSTORE [v0 + 1108], v0
hidden_4_done:
hidden_5:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 388]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 392]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 396]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 400]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 404]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 408]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 412]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 416]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 420]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 424]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 428]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 432]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 436]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 440]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 444]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 448]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_5_store_zero
VSTORE [v0 + 1112], v1
VCMPEQ p0, v0, v0
BRA hidden_5_done
hidden_5_store_zero:
VSTORE [v0 + 1112], v0
hidden_5_done:
hidden_6:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 452]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 456]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 460]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 464]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 468]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 472]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 476]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 480]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 484]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 488]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 492]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 496]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 500]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 504]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 508]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 512]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_6_store_zero
VSTORE [v0 + 1116], v1
VCMPEQ p0, v0, v0
BRA hidden_6_done
hidden_6_store_zero:
VSTORE [v0 + 1116], v0
hidden_6_done:
hidden_7:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 516]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 520]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 524]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 528]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 532]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 536]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 540]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 544]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 548]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 552]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 556]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 560]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 564]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 568]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 572]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 576]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_7_store_zero
VSTORE [v0 + 1120], v1
VCMPEQ p0, v0, v0
BRA hidden_7_done
hidden_7_store_zero:
VSTORE [v0 + 1120], v0
hidden_7_done:
hidden_8:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 580]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 584]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 588]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 592]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 596]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 600]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 604]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 608]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 612]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 616]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 620]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 624]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 628]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 632]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 636]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 640]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_8_store_zero
VSTORE [v0 + 1124], v1
VCMPEQ p0, v0, v0
BRA hidden_8_done
hidden_8_store_zero:
VSTORE [v0 + 1124], v0
hidden_8_done:
hidden_9:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 644]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 648]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 652]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 656]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 660]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 664]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 668]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 672]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 676]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 680]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 684]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 688]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 692]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 696]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 700]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 704]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_9_store_zero
VSTORE [v0 + 1128], v1
VCMPEQ p0, v0, v0
BRA hidden_9_done
hidden_9_store_zero:
VSTORE [v0 + 1128], v0
hidden_9_done:
hidden_10:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 708]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 712]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 716]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 720]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 724]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 728]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 732]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 736]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 740]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 744]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 748]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 752]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 756]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 760]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 764]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 768]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_10_store_zero
VSTORE [v0 + 1132], v1
VCMPEQ p0, v0, v0
BRA hidden_10_done
hidden_10_store_zero:
VSTORE [v0 + 1132], v0
hidden_10_done:
hidden_11:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 772]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 776]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 780]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 784]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 788]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 792]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 796]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 800]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 804]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 808]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 812]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 816]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 820]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 824]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 828]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 832]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_11_store_zero
VSTORE [v0 + 1136], v1
VCMPEQ p0, v0, v0
BRA hidden_11_done
hidden_11_store_zero:
VSTORE [v0 + 1136], v0
hidden_11_done:
hidden_12:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 836]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 840]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 844]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 848]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 852]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 856]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 860]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 864]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 868]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 872]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 876]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 880]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 884]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 888]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 892]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 896]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_12_store_zero
VSTORE [v0 + 1140], v1
VCMPEQ p0, v0, v0
BRA hidden_12_done
hidden_12_store_zero:
VSTORE [v0 + 1140], v0
hidden_12_done:
hidden_13:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 900]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 904]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 908]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 912]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 916]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 920]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 924]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 928]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 932]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 936]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 940]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 944]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 948]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 952]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 956]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 960]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_13_store_zero
VSTORE [v0 + 1144], v1
VCMPEQ p0, v0, v0
BRA hidden_13_done
hidden_13_store_zero:
VSTORE [v0 + 1144], v0
hidden_13_done:
hidden_14:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 964]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 968]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 972]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 976]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 980]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 984]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 988]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 992]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 996]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1000]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1004]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1008]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1012]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1016]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1020]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1024]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_14_store_zero
VSTORE [v0 + 1148], v1
VCMPEQ p0, v0, v0
BRA hidden_14_done
hidden_14_store_zero:
VSTORE [v0 + 1148], v0
hidden_14_done:
hidden_15:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1028]
VLOAD v3, [v0 + 4]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1032]
VLOAD v3, [v0 + 8]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1036]
VLOAD v3, [v0 + 12]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1040]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1044]
VLOAD v3, [v0 + 20]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1048]
VLOAD v3, [v0 + 24]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1052]
VLOAD v3, [v0 + 28]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1056]
VLOAD v3, [v0 + 32]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1060]
VLOAD v3, [v0 + 36]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1064]
VLOAD v3, [v0 + 40]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1068]
VLOAD v3, [v0 + 44]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1072]
VLOAD v3, [v0 + 48]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1076]
VLOAD v3, [v0 + 52]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1080]
VLOAD v3, [v0 + 56]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1084]
VLOAD v3, [v0 + 60]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1088]
VLOAD v3, [v0 + 64]
VMUL v4, v2, v3
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_15_store_zero
VSTORE [v0 + 1152], v1
VCMPEQ p0, v0, v0
BRA hidden_15_done
hidden_15_store_zero:
VSTORE [v0 + 1152], v0
hidden_15_done:
output_0:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1156]
VLOAD v3, [v0 + 1092]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1160]
VLOAD v3, [v0 + 1096]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1164]
VLOAD v3, [v0 + 1100]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1168]
VLOAD v3, [v0 + 1104]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1172]
VLOAD v3, [v0 + 1108]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1176]
VLOAD v3, [v0 + 1112]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1180]
VLOAD v3, [v0 + 1116]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1184]
VLOAD v3, [v0 + 1120]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1188]
VLOAD v3, [v0 + 1124]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1192]
VLOAD v3, [v0 + 1128]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1196]
VLOAD v3, [v0 + 1132]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1200]
VLOAD v3, [v0 + 1136]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1204]
VLOAD v3, [v0 + 1140]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1208]
VLOAD v3, [v0 + 1144]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1212]
VLOAD v3, [v0 + 1148]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1216]
VLOAD v3, [v0 + 1152]
VMUL v4, v2, v3
VADD v1, v1, v4
VSTORE [v0 + 1412], v1
output_1:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1220]
VLOAD v3, [v0 + 1092]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1224]
VLOAD v3, [v0 + 1096]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1228]
VLOAD v3, [v0 + 1100]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1232]
VLOAD v3, [v0 + 1104]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1236]
VLOAD v3, [v0 + 1108]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1240]
VLOAD v3, [v0 + 1112]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1244]
VLOAD v3, [v0 + 1116]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1248]
VLOAD v3, [v0 + 1120]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1252]
VLOAD v3, [v0 + 1124]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1256]
VLOAD v3, [v0 + 1128]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1260]
VLOAD v3, [v0 + 1132]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1264]
VLOAD v3, [v0 + 1136]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1268]
VLOAD v3, [v0 + 1140]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1272]
VLOAD v3, [v0 + 1144]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1276]
VLOAD v3, [v0 + 1148]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1280]
VLOAD v3, [v0 + 1152]
VMUL v4, v2, v3
VADD v1, v1, v4
VSTORE [v0 + 1416], v1
output_2:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1284]
VLOAD v3, [v0 + 1092]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1288]
VLOAD v3, [v0 + 1096]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1292]
VLOAD v3, [v0 + 1100]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1296]
VLOAD v3, [v0 + 1104]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1300]
VLOAD v3, [v0 + 1108]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1304]
VLOAD v3, [v0 + 1112]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1308]
VLOAD v3, [v0 + 1116]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1312]
VLOAD v3, [v0 + 1120]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1316]
VLOAD v3, [v0 + 1124]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1320]
VLOAD v3, [v0 + 1128]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1324]
VLOAD v3, [v0 + 1132]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1328]
VLOAD v3, [v0 + 1136]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1332]
VLOAD v3, [v0 + 1140]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1336]
VLOAD v3, [v0 + 1144]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1340]
VLOAD v3, [v0 + 1148]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1344]
VLOAD v3, [v0 + 1152]
VMUL v4, v2, v3
VADD v1, v1, v4
VSTORE [v0 + 1420], v1
output_3:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1348]
VLOAD v3, [v0 + 1092]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1352]
VLOAD v3, [v0 + 1096]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1356]
VLOAD v3, [v0 + 1100]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1360]
VLOAD v3, [v0 + 1104]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1364]
VLOAD v3, [v0 + 1108]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1368]
VLOAD v3, [v0 + 1112]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1372]
VLOAD v3, [v0 + 1116]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1376]
VLOAD v3, [v0 + 1120]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1380]
VLOAD v3, [v0 + 1124]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1384]
VLOAD v3, [v0 + 1128]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1388]
VLOAD v3, [v0 + 1132]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1392]
VLOAD v3, [v0 + 1136]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1396]
VLOAD v3, [v0 + 1140]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1400]
VLOAD v3, [v0 + 1144]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1404]
VLOAD v3, [v0 + 1148]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 1408]
VLOAD v3, [v0 + 1152]
VMUL v4, v2, v3
VADD v1, v1, v4
VSTORE [v0 + 1424], v1
.word 0xF0000000
