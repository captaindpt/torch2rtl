hidden_0:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 272]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 336]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 400]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 464]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_0_store_zero
VSTORE [v0 + 4368], v1
VCMPEQ p0, v0, v0
BRA hidden_0_done
hidden_0_store_zero:
VSTORE [v0 + 4368], v0
hidden_0_done:
hidden_1:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 528]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 592]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 656]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 720]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_1_store_zero
VSTORE [v0 + 4384], v1
VCMPEQ p0, v0, v0
BRA hidden_1_done
hidden_1_store_zero:
VSTORE [v0 + 4384], v0
hidden_1_done:
hidden_2:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 784]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 848]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 912]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 976]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_2_store_zero
VSTORE [v0 + 4400], v1
VCMPEQ p0, v0, v0
BRA hidden_2_done
hidden_2_store_zero:
VSTORE [v0 + 4400], v0
hidden_2_done:
hidden_3:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1040]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1104]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1168]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1232]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_3_store_zero
VSTORE [v0 + 4416], v1
VCMPEQ p0, v0, v0
BRA hidden_3_done
hidden_3_store_zero:
VSTORE [v0 + 4416], v0
hidden_3_done:
hidden_4:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1296]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1360]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1424]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1488]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_4_store_zero
VSTORE [v0 + 4432], v1
VCMPEQ p0, v0, v0
BRA hidden_4_done
hidden_4_store_zero:
VSTORE [v0 + 4432], v0
hidden_4_done:
hidden_5:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1552]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1616]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1680]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1744]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_5_store_zero
VSTORE [v0 + 4448], v1
VCMPEQ p0, v0, v0
BRA hidden_5_done
hidden_5_store_zero:
VSTORE [v0 + 4448], v0
hidden_5_done:
hidden_6:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 1808]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1872]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 1936]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2000]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_6_store_zero
VSTORE [v0 + 4464], v1
VCMPEQ p0, v0, v0
BRA hidden_6_done
hidden_6_store_zero:
VSTORE [v0 + 4464], v0
hidden_6_done:
hidden_7:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 2064]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2128]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2192]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2256]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_7_store_zero
VSTORE [v0 + 4480], v1
VCMPEQ p0, v0, v0
BRA hidden_7_done
hidden_7_store_zero:
VSTORE [v0 + 4480], v0
hidden_7_done:
hidden_8:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 2320]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2384]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2448]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2512]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_8_store_zero
VSTORE [v0 + 4496], v1
VCMPEQ p0, v0, v0
BRA hidden_8_done
hidden_8_store_zero:
VSTORE [v0 + 4496], v0
hidden_8_done:
hidden_9:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 2576]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2640]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2704]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2768]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_9_store_zero
VSTORE [v0 + 4512], v1
VCMPEQ p0, v0, v0
BRA hidden_9_done
hidden_9_store_zero:
VSTORE [v0 + 4512], v0
hidden_9_done:
hidden_10:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 2832]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2896]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 2960]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3024]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_10_store_zero
VSTORE [v0 + 4528], v1
VCMPEQ p0, v0, v0
BRA hidden_10_done
hidden_10_store_zero:
VSTORE [v0 + 4528], v0
hidden_10_done:
hidden_11:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 3088]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3152]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3216]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3280]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_11_store_zero
VSTORE [v0 + 4544], v1
VCMPEQ p0, v0, v0
BRA hidden_11_done
hidden_11_store_zero:
VSTORE [v0 + 4544], v0
hidden_11_done:
hidden_12:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 3344]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3408]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3472]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3536]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_12_store_zero
VSTORE [v0 + 4560], v1
VCMPEQ p0, v0, v0
BRA hidden_12_done
hidden_12_store_zero:
VSTORE [v0 + 4560], v0
hidden_12_done:
hidden_13:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 3600]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3664]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3728]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3792]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_13_store_zero
VSTORE [v0 + 4576], v1
VCMPEQ p0, v0, v0
BRA hidden_13_done
hidden_13_store_zero:
VSTORE [v0 + 4576], v0
hidden_13_done:
hidden_14:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 3856]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3920]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 3984]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 4048]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_14_store_zero
VSTORE [v0 + 4592], v1
VCMPEQ p0, v0, v0
BRA hidden_14_done
hidden_14_store_zero:
VSTORE [v0 + 4592], v0
hidden_14_done:
hidden_15:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 4112]
VLOAD v3, [v0 + 16]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 4176]
VLOAD v3, [v0 + 80]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 4240]
VLOAD v3, [v0 + 144]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VLOAD v2, [v0 + 4304]
VLOAD v3, [v0 + 208]
VMUL v4, v2, v3
VREDSUM v4, v4
VADD v1, v1, v4
VCMPLT p0, v1, v0
BRA hidden_15_store_zero
VSTORE [v0 + 4608], v1
VCMPEQ p0, v0, v0
BRA hidden_15_done
hidden_15_store_zero:
VSTORE [v0 + 4608], v0
hidden_15_done:
output_packed:
VLOAD v1, [v0 + 0]
VLOAD v2, [v0 + 4624]
VLOAD v3, [v0 + 4368]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4640]
VLOAD v3, [v0 + 4384]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4656]
VLOAD v3, [v0 + 4400]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4672]
VLOAD v3, [v0 + 4416]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4688]
VLOAD v3, [v0 + 4432]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4704]
VLOAD v3, [v0 + 4448]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4720]
VLOAD v3, [v0 + 4464]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4736]
VLOAD v3, [v0 + 4480]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4752]
VLOAD v3, [v0 + 4496]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4768]
VLOAD v3, [v0 + 4512]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4784]
VLOAD v3, [v0 + 4528]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4800]
VLOAD v3, [v0 + 4544]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4816]
VLOAD v3, [v0 + 4560]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4832]
VLOAD v3, [v0 + 4576]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4848]
VLOAD v3, [v0 + 4592]
VMUL v4, v2, v3
VADD v1, v1, v4
VLOAD v2, [v0 + 4864]
VLOAD v3, [v0 + 4608]
VMUL v4, v2, v3
VADD v1, v1, v4
VSTORE [v0 + 4880], v1
.word 0xF0000000
