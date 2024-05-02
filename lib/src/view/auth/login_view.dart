import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_app_clone_flutter/core/enums/route_enum.dart';
import 'package:tiktok_app_clone_flutter/core/extensions/context_extension.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/core/utils/global_var.dart';
import 'package:tiktok_app_clone_flutter/core/widgets/input_text_field.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static Widget page() => const LoginView();

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isObscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var authController = AuthController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/profile.png',
                    width: 200,
                  ),
                  Text(
                    'GUMMY',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    'Food entertainment platform',
                    style: GoogleFonts.saira(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InputTextField(
                    controller: emailController,
                    lableText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    isObscure: false,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 30),
                  InputTextField(
                    controller: passwordController,
                    lableText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isObscure: isObscure,
                    suffixIcon: InkWell(
                      radius: 50,
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: isObscure
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    prefixIcon: Icons.lock_outlined,
                  ),
                  const SizedBox(height: 30),

                  //*login button
                  //*not have an account, show signup button

                  showProgressBar == false
                      ? Column(
                          children: [
                            Container(
                              width: context.width,
                              height: 54,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  )),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    showProgressBar == true;
                                  });
                                  //login usr now
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    authController.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(RouteName.regist.toString());
                                  },
                                  child: const Text(
                                    "Singup here",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : SizedBox(
                          //show animation
                          height: 50,
                          width: 50,
                          child: SimpleCircularProgressBar(
                            progressColors: [
                              Colors.deepPurple,
                              Colors.purple.shade100,
                              Colors.purple.shade300,
                              Colors.deepPurple.shade200,
                              Colors.deepPurple,
                            ],
                            animationDuration: 1,
                            backColor: Colors.transparent,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
