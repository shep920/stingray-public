import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/cubits/kelp_memory/kelp_memory_cubit.dart';

class BlocSet{
  static void kelpMemories(BuildContext context, List<String> waveIds) {
    return (BlocProvider.of<KelpMemoryCubit>(context).updateMemory(waveIds));
  }
}