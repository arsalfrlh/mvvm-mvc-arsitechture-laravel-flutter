import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko/viewmodels/auth_viewmodel.dart';
import 'package:toko/views/home_view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class VerifyView extends StatefulWidget {
  const VerifyView({super.key});

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  String get otpCode =>otpControllers.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewmodel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF7643), Color(0xFFFFA53E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// 🔥 HEADER
              const Text(
                "Verifikasi OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Masukkan kode yang dikirim ke email kamu",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 40),

              /// 🔥 CARD FORM
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// 🔢 OTP BOX
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 50,
                            child: TextField(
                              controller: otpControllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 30),

                      /// 🔘 BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading
                          ? null
                          : () async {
                              final response = await authVM.verify(int.parse(otpCode));

                              AwesomeDialog(
                                context: context,
                                dialogType: response ? DialogType.success : DialogType.error,
                                animType: AnimType.scale,
                                title: response ? "Sukses" : "Error",
                                desc: authVM.message,
                                btnOkOnPress: () {
                                  if (response) {
                                    Navigator.pushAndRemoveUntil(
                                      context, MaterialPageRoute(builder: (_) => HomeView()), (route) => false,
                                    );
                                  }
                                },
                              ).show();
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7643),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 5,
                          ),
                          child: authVM.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Verifikasi",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔁 RESEND
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum menerima kode?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              // TODO: resend OTP
                            },
                            child: const Text(
                              "Kirim ulang",
                              style: TextStyle(
                                color: Color(0xFFFF7643),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// ⏱️ TIMER (optional)
                      const Text(
                        "Kirim ulang dalam 00:30",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}