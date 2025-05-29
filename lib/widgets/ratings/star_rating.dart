import 'package:coffee2u/config/index.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    this.data,
    this.onChanged,
    this.selectedRating,
    this.score,
    this.size,
  });
  final List<Map<String, dynamic>>? data;
  final Function(Map<String, dynamic> value)? onChanged;
  final Map<String, dynamic>? selectedRating;

  final double? score;
  final double? size;
  
  @override
  Widget build(BuildContext context) {

    if(score != null && (data == null || data?.isEmpty == true || onChanged == null)){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [1,2,3,4,5].map((e) {
          return Icon(
            Icons.star_rounded,
            color: score! >= e
            ? kYellowColor
            : kLightColor,
            size: size,
          );
        }).toList(),
      );
    }else{
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: data!.map((d) {

          return GestureDetector(
            onTap: () => onChanged!(d),
            child: Icon(
              Icons.star_rounded,
              color: selectedRating != null && d['value'] <= selectedRating?['value']
              ? kYellowColor
              : kLightColor,
              size: size,
            ),
          );
        }).toList(),
      );
    }
    
  }
}