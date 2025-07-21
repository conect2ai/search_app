// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';

// import '../../../../core/themes/app_colors.dart';
// import '../../../../core/themes/app_text_styles.dart';
// import '../view_models/api_key_viewmodel.dart';

// class SelectProviderPage extends StatefulWidget {
//   const SelectProviderPage({super.key});

//   @override
//   State<SelectProviderPage> createState() => _SelectProviderPageState();
// }

// class _SelectProviderPageState extends State<SelectProviderPage> {
//   final _viewModel = Modular.get<ApiKeyViewModel>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Selecione o provedor da chave',
//               style: AppTextStyles.mainTextStyle),
//           const SizedBox(
//             height: 30,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.mainColor,
//                 ),
//                 onPressed: () async {
//                   print('OpenAI selecionada');
//                   try {
//                     _viewModel.checkApiKey();
//                     Modular.to.pushReplacementNamed('/api-key/load-api-key');
//                   } catch (e) {
//                     print('Erro ao verificar a chave da API: $e');
//                   }
//                 },
//                 child: const Text('OpenAI'),
//               ),
//               const SizedBox(
//                 width: 30,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.mainColor,
//                 ),
//                 onPressed: () {
//                   print('Gemini selecionado');
//                 },
//                 child: const Text('Gemini'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
