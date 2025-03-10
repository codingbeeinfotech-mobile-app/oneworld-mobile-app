// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
//
// class CommonMultiselectionDropdown extends StatelessWidget {
//   void Function(List<String>?)? onSaved;
//   String? Function(List<String>?)? validator;
//   AutovalidateMode? autoValidateMode = AutovalidateMode.disabled;
//   void Function(List<String>?) onChangedsearch;
//   List<String> items;
//   String dropdownselecttitle;
//   double containerwidth;
//   double containerheight;
//   TextStyle? textstyle;
//   Widget? prefix;
//   Color? containercolor;
//   Widget? dropdownicon;
//   BorderRadius? borderRadius;
//   List<String>? selectedItems;
//   Future<List<String>> Function(String)? asyncItems;
//   Widget Function(BuildContext, String?)? dropdownBuilder;
//   DropDownDecoratorProps dropdownDecoratorProps =
//   const DropDownDecoratorProps();
//   ClearButtonProps clearButtonProps = const ClearButtonProps();
//   DropdownButtonProps dropdownButtonProps = const DropdownButtonProps();
//   bool enabled = true;
//   BoxBorder? border;
//   bool Function(String, String)? filterFn;
//   String Function(String)? itemAsString;
//   bool Function(String, String)? compareFn;
//   Future<bool?> Function(List<String>, List<String>)? onBeforeChange;
//   Future<bool?> Function(List<String>)? onBeforePopupOpening;
//   PopupPropsMultiSelection<String>? popupProps;
//   final List<String>? dropdownValue;
//   int elevation;
//   Widget? dropdowntitle;
//   bool isExpanded;
//   Widget? dropdownsuffix;
//
//    CommonMultiselectionDropdown({
//     this.dropdownValue,
//     required this.containerwidth,
//     required this.dropdownselecttitle,
//     required this.containerheight,
//     this.dropdowntitle,
//     this.textstyle,
//     this.containercolor,
//     this.dropdownicon,
//     this.borderRadius,
//     this.border,
//     required this.isExpanded,
//     super.key,
//     this.dropdownsuffix,
//     this.onSaved,
//     required this.elevation,
//     this.validator,
//     this.autoValidateMode,
//     this.prefix,
//     required this.onChangedsearch,
//     required this.items,
//     this.selectedItems,
//     this.asyncItems,
//     this.dropdownBuilder,
//     required this.dropdownDecoratorProps,
//     required this.clearButtonProps,
//     required this.dropdownButtonProps,
//     required this.enabled,
//     this.filterFn,
//     this.itemAsString,
//     this.compareFn,
//     this.onBeforeChange,
//     this.onBeforePopupOpening,
//     this.popupProps,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           width: containerwidth,
//           height: containerheight ?? height * 0.06,
//           decoration: BoxDecoration(
//             color: containercolor,
//             border: border,
//             borderRadius: borderRadius,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Container(
//                   width: containerwidth,
//                   height: containerheight,
//                   color: containercolor,
//                   child: DropdownSearch<String>.multiSelection(
//                     selectedItems: selectedItems ?? dropdownValue!,
//                     onSaved: onSaved,
//                     validator: validator,
//                     autoValidateMode: autoValidateMode,
//                     onChanged: onChangedsearch,
//                     items: items,
//                     asyncItems: asyncItems,
//                     dropdownBuilder: _style,
//                     dropdownDecoratorProps: dropdownDecoratorProps,
//                     clearButtonProps: clearButtonProps,
//                     dropdownButtonProps: dropdownButtonProps,
//                     enabled: enabled,
//                     filterFn: filterFn,
//                     itemAsString: itemAsString,
//                     compareFn: compareFn,
//                     onBeforeChange: onBeforeChange,
//                     onBeforePopupOpening: onBeforePopupOpening,
//                     popupProps: PopupPropsMultiSelection.menu(
//                       fit: FlexFit.loose,
//                       title: dropdowntitle,
//                       onItemAdded: (selectedItems, addedItem) {
//                         // log('selectedItems $selectedItems');
//                       },
//                       onItemRemoved: (selectedItems, removedItem) {
//                         // log('removedItem $removedItem');
//                         // log('selectedItems $selectedItems');
//                       },
//                       emptyBuilder: (context, searchEntry) {
//                         return Container(
//                           height: height * 0.05,
//                           width: width * 0.3,
//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               color: AppColors.black.withOpacity(0.2),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'No Data Found',
//                               style: ptSansTextStyle(
//                                 color: AppColors.black.withOpacity(0.8),
//                                 fontSize: height * 0.02,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       containerBuilder: (context, child) {
//                         return Container(
//                           color: containercolor,
//                           child: child,
//                         );
//                       },
//                       itemBuilder: (context, item, isSelected,select) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: height * 0.006,
//                               horizontal: width * 0.025),
//                           child: Container(
//                             height: height * 0.025,
//                             color: containercolor,
//                             child: Row(
//                               children: [
//                                 dropdownicon != null
//                                     ? dropdownicon!
//                                     : const SizedBox.shrink(),
//                                 Expanded(
//                                   child: Text(
//                                     item,
//                                     maxLines: 3,
//                                     style: ptSansTextStyle(
//                                         color: AppColors.black.withOpacity(0.8),
//                                         fontSize: width * 0.035,
//                                         overflow: TextOverflow.ellipsis,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 dropdownsuffix != null
//                                     ? dropdownsuffix!
//                                     : const SizedBox.shrink(),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       constraints: const BoxConstraints.tightFor(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _style1(BuildContext context, String? item, bool isSelected) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       height: height * 0.025,
//       child: Row(
//         children: [
//           const Icon(Icons.location_on),
//           Text(
//             item!,
//             style: ptSansTextStyle(
//                 color: AppColors.black.withOpacity(0.8),
//                 fontSize: height * 0.02,
//                 fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
//
