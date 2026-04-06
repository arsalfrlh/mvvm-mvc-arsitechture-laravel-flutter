<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification</title>
</head>
<body style="margin:0; padding:0; background:#fff4ed; font-family: 'Segoe UI', Arial, sans-serif;">

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">

                <!-- Card -->
                <table width="420" cellpadding="0" cellspacing="0" style="background:#ffffff; margin:40px auto; border-radius:16px; overflow:hidden; box-shadow:0 10px 30px rgba(0,0,0,0.1);">

                    <!-- Header -->
                    <tr>
                        <td style="background:linear-gradient(135deg, #ff7a00, #ffb347); padding:30px; text-align:center; color:white;">
                            <h1 style="margin:0; font-size:24px;">🔐 Verifikasi OTP</h1>
                            <p style="margin:5px 0 0; font-size:14px; opacity:0.9;">
                                Keamanan akun Anda adalah prioritas kami
                            </p>
                        </td>
                    </tr>

                    <!-- Body -->
                    <tr>
                        <td style="padding:30px;">

                            <!-- Greeting -->
                            <p style="font-size:16px; color:#333;">
                                Hallo <strong>{{ $name }}</strong> 👋
                            </p>

                            <!-- Message -->
                            <p style="font-size:14px; color:#555; line-height:1.6;">
                                Gunakan kode OTP berikut untuk melanjutkan proses verifikasi akun Anda. Jangan bagikan kode ini kepada siapapun.
                            </p>

                            <!-- OTP Box -->
                            <div style="text-align:center; margin:30px 0;">
                                <div style="
                                    display:inline-block;
                                    background:linear-gradient(135deg, #ff7a00, #ffb347);
                                    color:white;
                                    padding:18px 35px;
                                    font-size:32px;
                                    letter-spacing:8px;
                                    border-radius:12px;
                                    font-weight:bold;
                                    box-shadow:0 5px 15px rgba(255,122,0,0.4);
                                ">
                                    {{ $otp }}
                                </div>
                            </div>

                            <!-- Info -->
                            <p style="font-size:13px; color:#888; text-align:center;">
                                ⏳ Berlaku selama 5 menit
                            </p>

                            <!-- Divider -->
                            <hr style="border:none; border-top:1px solid #eee; margin:25px 0;">

                            <!-- Warning -->
                            <p style="font-size:12px; color:#999; text-align:center; line-height:1.5;">
                                Jika Anda tidak meminta kode ini, silakan abaikan email ini.<br>
                                Jangan pernah membagikan OTP kepada siapa pun.
                            </p>

                        </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td style="background:#fff4ed; padding:15px; text-align:center; font-size:12px; color:#aaa;">
                            © 2026 Your App • All Rights Reserved
                        </td>
                    </tr>

                </table>

            </td>
        </tr>
    </table>

</body>
</html>