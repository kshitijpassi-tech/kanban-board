import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import '../../data/models/user_model.dart';
import '../../domain/entities/task_entity.dart';
import '../states/auth_state_notifier.dart';
import '../states/kanban_state_notifier.dart';
import 'auth_providers.dart';
import 'helper_providers.dart';
import 'task_providers.dart';

// Kanban State Notifier Provider
final kanbanStateNotifierProvider =
    StateNotifierProvider<KanbanStateNotifier, AsyncValue<List<TaskEntity>>>((
      ref,
    ) {
      final firebaseHelper = ref.read(firebaseHelperProvider);
      final User? user = firebaseHelper.currentUser;

      return KanbanStateNotifier(
        getTasks: ref.read(getTaskProvider),
        addTask: ref.read(addTaskProvider),
        updateTask: ref.read(updateTaskProvider),
        deleteTask: ref.read(deleteTaskProvider),
        userId: user?.uid ?? '',
      );
    });

// Auth State Notifier Provider
final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
      final getCurrentUser = ref.read(getCurrentUserProvider);
      final isLoggedIn = ref.read(isLoggedInProvider);
      final loginUser = ref.read(loginUserProvider);
      final registerUser = ref.read(registerUserProvider);
      final logoutUser = ref.refresh(logoutProvider);

      return AuthStateNotifier(
        getCurrentUser,
        isLoggedIn,
        loginUser,
        registerUser,
        logoutUser,
      );
    });
