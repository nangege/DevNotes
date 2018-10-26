import Foundation

let outputText = """
2018-10-19 16:13:24.544145+0800 YYKitDemo[1934:459024] time: 360.77
2018-10-19 16:13:24.570439+0800 YYKitDemo[1934:459024] time: 26.12
2018-10-19 16:13:24.580200+0800 YYKitDemo[1934:459024] time: 9.13
2018-10-19 16:13:24.589301+0800 YYKitDemo[1934:459024] time: 8.94
2018-10-19 16:13:24.599242+0800 YYKitDemo[1934:459024] time: 9.80
2018-10-19 16:13:24.609978+0800 YYKitDemo[1934:459024] time: 10.52
2018-10-19 16:13:24.613364+0800 YYKitDemo[1934:459024] time: 3.24
2018-10-19 16:13:24.619431+0800 YYKitDemo[1934:459024] time: 5.95
2018-10-19 16:13:24.631873+0800 YYKitDemo[1934:459024] time: 12.32
2018-10-19 16:13:24.641208+0800 YYKitDemo[1934:459024] time: 9.20
2018-10-19 16:13:24.643643+0800 YYKitDemo[1934:459024] time: 2.31
2018-10-19 16:13:24.649664+0800 YYKitDemo[1934:459024] time: 5.92
2018-10-19 16:13:24.659093+0800 YYKitDemo[1934:459024] time: 9.31
2018-10-19 16:13:24.679895+0800 YYKitDemo[1934:459024] time: 20.19
2018-10-19 16:13:24.682927+0800 YYKitDemo[1934:459024] time: 2.90
2018-10-19 16:13:24.690000+0800 YYKitDemo[1934:459024] time: 6.96
2018-10-19 16:13:24.693729+0800 YYKitDemo[1934:459024] time: 3.61
2018-10-19 16:13:24.697932+0800 YYKitDemo[1934:459024] time: 4.09
2018-10-19 16:13:24.709153+0800 YYKitDemo[1934:459024] time: 11.11
2018-10-19 16:13:24.713699+0800 YYKitDemo[1934:459024] time: 4.42
2018-10-19 16:13:24.720138+0800 YYKitDemo[1934:459024] time: 6.33
2018-10-19 16:13:24.724081+0800 YYKitDemo[1934:459024] time: 3.75
2018-10-19 16:13:24.728342+0800 YYKitDemo[1934:459024] time: 4.16
2018-10-19 16:13:24.732181+0800 YYKitDemo[1934:459024] time: 3.72
2018-10-19 16:13:24.738720+0800 YYKitDemo[1934:459024] time: 6.42
2018-10-19 16:13:24.742736+0800 YYKitDemo[1934:459024] time: 3.83
2018-10-19 16:13:24.745620+0800 YYKitDemo[1934:459024] time: 2.72
2018-10-19 16:13:24.792793+0800 YYKitDemo[1934:459024] time: 16.33
2018-10-19 16:13:24.808597+0800 YYKitDemo[1934:459024] time: 15.67
2018-10-19 16:13:24.811878+0800 YYKitDemo[1934:459024] time: 3.16
2018-10-19 16:13:24.817469+0800 YYKitDemo[1934:459024] time: 5.49
2018-10-19 16:13:24.824286+0800 YYKitDemo[1934:459024] time: 6.71
2018-10-19 16:13:24.827788+0800 YYKitDemo[1934:459024] time: 3.38
2018-10-19 16:13:24.832937+0800 YYKitDemo[1934:459024] time: 5.05
2018-10-19 16:13:24.839630+0800 YYKitDemo[1934:459024] time: 6.58
2018-10-19 16:13:24.845703+0800 YYKitDemo[1934:459024] time: 5.95
2018-10-19 16:13:24.856575+0800 YYKitDemo[1934:459024] time: 10.75
2018-10-19 16:13:24.860717+0800 YYKitDemo[1934:459024] time: 4.01
2018-10-19 16:13:24.870723+0800 YYKitDemo[1934:459024] time: 9.89
2018-10-19 16:13:24.873840+0800 YYKitDemo[1934:459024] time: 2.99
2018-10-19 16:13:24.876885+0800 YYKitDemo[1934:459024] time: 2.93
2018-10-19 16:13:24.897741+0800 YYKitDemo[1934:459024] time: 20.74
2018-10-19 16:13:24.904805+0800 YYKitDemo[1934:459024] time: 6.92
2018-10-19 16:13:24.914509+0800 YYKitDemo[1934:459024] time: 9.58
2018-10-19 16:13:24.918582+0800 YYKitDemo[1934:459024] time: 3.93
2018-10-19 16:13:24.924390+0800 YYKitDemo[1934:459024] time: 5.68
2018-10-19 16:13:24.932867+0800 YYKitDemo[1934:459024] time: 8.37
2018-10-19 16:13:24.938482+0800 YYKitDemo[1934:459024] time: 5.49
2018-10-19 16:13:24.941067+0800 YYKitDemo[1934:459024] time: 2.47
2018-10-19 16:13:24.944406+0800 YYKitDemo[1934:459024] time: 3.23
2018-10-19 16:13:24.955099+0800 YYKitDemo[1934:459024] time: 10.58
2018-10-19 16:13:24.957462+0800 YYKitDemo[1934:459024] time: 2.23
2018-10-19 16:13:24.960023+0800 YYKitDemo[1934:459024] time: 2.45
2018-10-19 16:13:25.006075+0800 YYKitDemo[1934:459024] time: 5.23
2018-10-19 16:13:25.017665+0800 YYKitDemo[1934:459024] time: 11.45
2018-10-19 16:13:25.021668+0800 YYKitDemo[1934:459024] time: 3.89
2018-10-19 16:13:25.025734+0800 YYKitDemo[1934:459024] time: 3.96
2018-10-19 16:13:25.030448+0800 YYKitDemo[1934:459024] time: 4.60
2018-10-19 16:13:25.037344+0800 YYKitDemo[1934:459024] time: 6.75
2018-10-19 16:13:25.042481+0800 YYKitDemo[1934:459024] time: 4.98
2018-10-19 16:13:25.046024+0800 YYKitDemo[1934:459024] time: 3.44
2018-10-19 16:13:25.048527+0800 YYKitDemo[1934:459024] time: 2.29
2018-10-19 16:13:25.054125+0800 YYKitDemo[1934:459024] time: 5.35
2018-10-19 16:13:25.058785+0800 YYKitDemo[1934:459024] time: 4.54
2018-10-19 16:13:25.060744+0800 YYKitDemo[1934:459024] time: 1.85
2018-10-19 16:13:25.062892+0800 YYKitDemo[1934:459024] time: 2.05
2018-10-19 16:13:25.065466+0800 YYKitDemo[1934:459024] time: 2.47
2018-10-19 16:13:25.069736+0800 YYKitDemo[1934:459024] time: 3.98
2018-10-19 16:13:25.073712+0800 YYKitDemo[1934:459024] time: 3.85
2018-10-19 16:13:25.076300+0800 YYKitDemo[1934:459024] time: 2.47
2018-10-19 16:13:25.079240+0800 YYKitDemo[1934:459024] time: 2.84
2018-10-19 16:13:25.081414+0800 YYKitDemo[1934:459024] time: 2.08
2018-10-19 16:13:25.086996+0800 YYKitDemo[1934:459024] time: 5.48
2018-10-19 16:13:25.089980+0800 YYKitDemo[1934:459024] time: 2.88
2018-10-19 16:13:25.093160+0800 YYKitDemo[1934:459024] time: 3.07
2018-10-19 16:13:25.096091+0800 YYKitDemo[1934:459024] time: 2.83
2018-10-19 16:13:25.098842+0800 YYKitDemo[1934:459024] time: 2.65
2018-10-19 16:13:25.102676+0800 YYKitDemo[1934:459024] time: 3.72
2018-10-19 16:13:25.105697+0800 YYKitDemo[1934:459024] time: 2.91
2018-10-19 16:13:25.171384+0800 YYKitDemo[1934:459024] time: 13.23
2018-10-19 16:13:25.175158+0800 YYKitDemo[1934:459024] time: 3.67
2018-10-19 16:13:25.177676+0800 YYKitDemo[1934:459024] time: 2.42
2018-10-19 16:13:25.180575+0800 YYKitDemo[1934:459024] time: 2.80
2018-10-19 16:13:25.186134+0800 YYKitDemo[1934:459024] time: 5.46
2018-10-19 16:13:25.190033+0800 YYKitDemo[1934:459024] time: 3.79
2018-10-19 16:13:25.192984+0800 YYKitDemo[1934:459024] time: 2.85
2018-10-19 16:13:25.196143+0800 YYKitDemo[1934:459024] time: 3.05
2018-10-19 16:13:25.199478+0800 YYKitDemo[1934:459024] time: 3.23
2018-10-19 16:13:25.204198+0800 YYKitDemo[1934:459024] time: 4.30
2018-10-19 16:13:25.206631+0800 YYKitDemo[1934:459024] time: 2.33
2018-10-19 16:13:25.208690+0800 YYKitDemo[1934:459024] time: 1.96
2018-10-19 16:13:25.212703+0800 YYKitDemo[1934:459024] time: 3.92
2018-10-19 16:13:25.222546+0800 YYKitDemo[1934:459024] time: 9.73
2018-10-19 16:13:25.227213+0800 YYKitDemo[1934:459024] time: 4.55
2018-10-19 16:13:25.230552+0800 YYKitDemo[1934:459024] time: 3.16
2018-10-19 16:13:25.236956+0800 YYKitDemo[1934:459024] time: 6.28
2018-10-19 16:13:25.244502+0800 YYKitDemo[1934:459024] time: 7.41
2018-10-19 16:13:25.247064+0800 YYKitDemo[1934:459024] time: 2.42
2018-10-19 16:13:25.249545+0800 YYKitDemo[1934:459024] time: 2.34
2018-10-19 16:13:25.254265+0800 YYKitDemo[1934:459024] time: 4.60
2018-10-19 16:13:25.258527+0800 YYKitDemo[1934:459024] time: 4.15
2018-10-19 16:13:25.262340+0800 YYKitDemo[1934:459024] time: 3.70
2018-10-19 16:13:25.266076+0800 YYKitDemo[1934:459024] time: 3.44
2018-10-19 16:13:25.273225+0800 YYKitDemo[1934:459024] time: 5.18
2018-10-19 16:13:25.326144+0800 YYKitDemo[1934:459024] time: 14.68
2018-10-19 16:13:25.335379+0800 YYKitDemo[1934:459024] time: 9.08
2018-10-19 16:13:25.340480+0800 YYKitDemo[1934:459024] time: 4.78
2018-10-19 16:13:25.345118+0800 YYKitDemo[1934:459024] time: 4.06
2018-10-19 16:13:25.347738+0800 YYKitDemo[1934:459024] time: 2.52
2018-10-19 16:13:25.355153+0800 YYKitDemo[1934:459024] time: 7.31
2018-10-19 16:13:25.359910+0800 YYKitDemo[1934:459024] time: 4.64
2018-10-19 16:13:25.370192+0800 YYKitDemo[1934:459024] time: 10.17
2018-10-19 16:13:25.374935+0800 YYKitDemo[1934:459024] time: 4.62
2018-10-19 16:13:25.379244+0800 YYKitDemo[1934:459024] time: 4.20
2018-10-19 16:13:25.381206+0800 YYKitDemo[1934:459024] time: 1.87
2018-10-19 16:13:25.385197+0800 YYKitDemo[1934:459024] time: 3.89
2018-10-19 16:13:25.387922+0800 YYKitDemo[1934:459024] time: 2.62
2018-10-19 16:13:25.389975+0800 YYKitDemo[1934:459024] time: 1.96
2018-10-19 16:13:25.397028+0800 YYKitDemo[1934:459024] time: 6.96
2018-10-19 16:13:25.401852+0800 YYKitDemo[1934:459024] time: 4.71
2018-10-19 16:13:25.406413+0800 YYKitDemo[1934:459024] time: 4.44
2018-10-19 16:13:25.412347+0800 YYKitDemo[1934:459024] time: 5.61
2018-10-19 16:13:25.415667+0800 YYKitDemo[1934:459024] time: 3.21
2018-10-19 16:13:25.421005+0800 YYKitDemo[1934:459024] time: 5.22
2018-10-19 16:13:25.424231+0800 YYKitDemo[1934:459024] time: 3.11
2018-10-19 16:13:25.426778+0800 YYKitDemo[1934:459024] time: 2.44
2018-10-19 16:13:25.429029+0800 YYKitDemo[1934:459024] time: 2.15
2018-10-19 16:13:25.431258+0800 YYKitDemo[1934:459024] time: 2.13
2018-10-19 16:13:25.436262+0800 YYKitDemo[1934:459024] time: 4.90
2018-10-19 16:13:25.472200+0800 YYKitDemo[1934:459024] time: 1.92
2018-10-19 16:13:25.474241+0800 YYKitDemo[1934:459024] time: 1.92
2018-10-19 16:13:25.478586+0800 YYKitDemo[1934:459024] time: 4.25
2018-10-19 16:13:25.485142+0800 YYKitDemo[1934:459024] time: 6.43
2018-10-19 16:13:25.494010+0800 YYKitDemo[1934:459024] time: 8.75
2018-10-19 16:13:25.498355+0800 YYKitDemo[1934:459024] time: 4.21
2018-10-19 16:13:25.504687+0800 YYKitDemo[1934:459024] time: 6.22
2018-10-19 16:13:25.507955+0800 YYKitDemo[1934:459024] time: 3.15
2018-10-19 16:13:25.515445+0800 YYKitDemo[1934:459024] time: 7.38
2018-10-19 16:13:25.521123+0800 YYKitDemo[1934:459024] time: 5.56
2018-10-19 16:13:25.525843+0800 YYKitDemo[1934:459024] time: 4.61
2018-10-19 16:13:25.529714+0800 YYKitDemo[1934:459024] time: 3.78
2018-10-19 16:13:25.535090+0800 YYKitDemo[1934:459024] time: 5.27
2018-10-19 16:13:25.543626+0800 YYKitDemo[1934:459024] time: 8.42
2018-10-19 16:13:25.547966+0800 YYKitDemo[1934:459024] time: 4.22
2018-10-19 16:13:25.554118+0800 YYKitDemo[1934:459024] time: 6.04
2018-10-19 16:13:25.558226+0800 YYKitDemo[1934:459024] time: 3.99
2018-10-19 16:13:25.560979+0800 YYKitDemo[1934:459024] time: 2.65
2018-10-19 16:13:25.564633+0800 YYKitDemo[1934:459024] time: 3.55
2018-10-19 16:13:25.575327+0800 YYKitDemo[1934:459024] time: 10.57
2018-10-19 16:13:25.580048+0800 YYKitDemo[1934:459024] time: 4.59
2018-10-19 16:13:25.590766+0800 YYKitDemo[1934:459024] time: 10.60
2018-10-19 16:13:25.595387+0800 YYKitDemo[1934:459024] time: 4.50
2018-10-19 16:13:25.598187+0800 YYKitDemo[1934:459024] time: 2.70
2018-10-19 16:13:25.602696+0800 YYKitDemo[1934:459024] time: 4.41
2018-10-19 16:13:25.631557+0800 YYKitDemo[1934:459024] time: 1.98
2018-10-19 16:13:25.636350+0800 YYKitDemo[1934:459024] time: 4.66
2018-10-19 16:13:25.646488+0800 YYKitDemo[1934:459024] time: 10.02
2018-10-19 16:13:25.649155+0800 YYKitDemo[1934:459024] time: 2.55
2018-10-19 16:13:25.661713+0800 YYKitDemo[1934:459024] time: 10.95
2018-10-19 16:13:25.663901+0800 YYKitDemo[1934:459024] time: 2.07
2018-10-19 16:13:25.669065+0800 YYKitDemo[1934:459024] time: 5.06
2018-10-19 16:13:25.672164+0800 YYKitDemo[1934:459024] time: 3.00
2018-10-19 16:13:25.674581+0800 YYKitDemo[1934:459024] time: 2.31
2018-10-19 16:13:25.677575+0800 YYKitDemo[1934:459024] time: 2.89
2018-10-19 16:13:25.687734+0800 YYKitDemo[1934:459024] time: 10.05
2018-10-19 16:13:25.690447+0800 YYKitDemo[1934:459024] time: 2.60
2018-10-19 16:13:25.693422+0800 YYKitDemo[1934:459024] time: 2.88
2018-10-19 16:13:25.695607+0800 YYKitDemo[1934:459024] time: 2.09
2018-10-19 16:13:25.704755+0800 YYKitDemo[1934:459024] time: 9.04
2018-10-19 16:13:25.708746+0800 YYKitDemo[1934:459024] time: 3.88
2018-10-19 16:13:25.711538+0800 YYKitDemo[1934:459024] time: 2.69
2018-10-19 16:13:25.714489+0800 YYKitDemo[1934:459024] time: 2.85
2018-10-19 16:13:25.720383+0800 YYKitDemo[1934:459024] time: 5.79
2018-10-19 16:13:25.728706+0800 YYKitDemo[1934:459024] time: 8.21
2018-10-19 16:13:25.737213+0800 YYKitDemo[1934:459024] time: 8.38
2018-10-19 16:13:25.740912+0800 YYKitDemo[1934:459024] time: 3.57
2018-10-19 16:13:25.745028+0800 YYKitDemo[1934:459024] time: 4.00
2018-10-19 16:13:25.747564+0800 YYKitDemo[1934:459024] time: 2.42
2018-10-19 16:13:25.751879+0800 YYKitDemo[1934:459024] time: 4.21
2018-10-19 16:13:25.785974+0800 YYKitDemo[1934:459024] time: 3.85
2018-10-19 16:13:25.790674+0800 YYKitDemo[1934:459024] time: 4.54
2018-10-19 16:13:25.796384+0800 YYKitDemo[1934:459024] time: 5.60
2018-10-19 16:13:25.801085+0800 YYKitDemo[1934:459024] time: 4.59
2018-10-19 16:13:25.806414+0800 YYKitDemo[1934:459024] time: 5.20
2018-10-19 16:13:25.810057+0800 YYKitDemo[1934:459024] time: 2.69
2018-10-19 16:13:25.817322+0800 YYKitDemo[1934:459024] time: 7.15
2018-10-19 16:13:25.821594+0800 YYKitDemo[1934:459024] time: 4.15
2018-10-19 16:13:25.838497+0800 YYKitDemo[1934:459024] time: 16.77
2018-10-19 16:13:25.846078+0800 YYKitDemo[1934:459024] time: 7.36
2018-10-19 16:13:25.855277+0800 YYKitDemo[1934:459024] time: 9.07
2018-10-19 16:13:25.860280+0800 YYKitDemo[1934:459024] time: 4.89
2018-10-19 16:13:25.870843+0800 YYKitDemo[1934:459024] time: 10.44
2018-10-19 16:13:25.874828+0800 YYKitDemo[1934:459024] time: 3.34
2018-10-19 16:13:25.880648+0800 YYKitDemo[1934:459024] time: 5.68
2018-10-19 16:13:25.892431+0800 YYKitDemo[1934:459024] time: 11.65
2018-10-19 16:13:25.894997+0800 YYKitDemo[1934:459024] time: 2.44
2018-10-19 16:13:25.898023+0800 YYKitDemo[1934:459024] time: 2.92
2018-10-19 16:13:25.903572+0800 YYKitDemo[1934:459024] time: 5.41
2018-10-19 16:13:25.908096+0800 YYKitDemo[1934:459024] time: 3.82
2018-10-19 16:13:25.910799+0800 YYKitDemo[1934:459024] time: 2.59
2018-10-19 16:13:25.914317+0800 YYKitDemo[1934:459024] time: 3.41
2018-10-19 16:13:25.920648+0800 YYKitDemo[1934:459024] time: 6.22
2018-10-19 16:13:25.923510+0800 YYKitDemo[1934:459024] time: 2.76
2018-10-19 16:13:25.927085+0800 YYKitDemo[1934:459024] time: 3.48
2018-10-19 16:13:25.929832+0800 YYKitDemo[1934:459024] time: 2.65
2018-10-19 16:13:25.936821+0800 YYKitDemo[1934:459024] time: 6.87
"""
outputText.split(separator: "\n").map{ String($0.split(separator: "]").last!).replacingOccurrences(of: "time", with: "YYKit")}.forEach{ print($0)}

