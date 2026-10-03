#define _GNU_SOURCE
#include <dlfcn.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* Captured at load time — this is the PATH from your shell/session,
   before TurboPrint strips it. */
static char *saved_path;

__attribute__((constructor))
static void capture_path(void) {
    const char *p = getenv("PATH");
    if (p && *p) saved_path = strdup(p);
}

static const char *path_value(void) {
    return (saved_path && *saved_path) ? saved_path : "/run/current-system/sw/bin";
}

/* ---- 1. Defend PATH in the process's environ ---- */

int unsetenv(const char *name) {
    static int (*real)(const char *);
    if (!real) real = dlsym(RTLD_NEXT, "unsetenv");
    if (name && strcmp(name, "PATH") == 0) return 0;   /* refuse */
    return real(name);
}

int putenv(char *string) {
    static int (*real)(char *);
    if (!real) real = dlsym(RTLD_NEXT, "putenv");
    if (string && strncmp(string, "PATH=", 5) == 0) return 0;
    return real(string);
}

int setenv(const char *name, const char *value, int overwrite) {
    static int (*real)(const char *, const char *, int);
    if (!real) real = dlsym(RTLD_NEXT, "setenv");
    if (name && strcmp(name, "PATH") == 0) return 0;   /* refuse */
    return real(name, value, overwrite);
}

/* ---- 2. Guarantee PATH at every exec boundary ---- */

static char **ensure_path(char *const envp[]) {
    if (envp == NULL) return (char **)envp;

    const char *pv = path_value();

    for (char *const *e = envp; *e; e++)
        if (strncmp(*e, "PATH=", 5) == 0 && strcmp(*e + 5, pv) == 0)
            return (char **)envp;   /* already correct */

    int n = 0;
    while (envp[n]) n++;

    char **ne = malloc((n + 2) * sizeof(char *));
    if (!ne) return (char **)envp;

    int j = 0;
    for (int i = 0; i < n; i++)
        if (strncmp(envp[i], "PATH=", 5) != 0) ne[j++] = envp[i];

    if (asprintf(&ne[j], "PATH=%s", pv) < 0) { free(ne); return (char **)envp; }
    ne[j + 1] = NULL;
    return ne;
}

int execve(const char *path, char *const argv[], char *const envp[]) {
    static int (*real)(const char *, char *const[], char *const[]);
    if (!real) real = dlsym(RTLD_NEXT, "execve");
    return real(path, argv, ensure_path(envp));
}

int execv(const char *path, char *const argv[]) {
    extern char **environ;
    return execve(path, argv, environ);
}

int execvp(const char *file, char *const argv[]) {
    static int (*real)(const char *, char *const[]);
    if (!real) real = dlsym(RTLD_NEXT, "execvp");
    setenv("PATH", path_value(), 0);   /* ensure lookup works */
    return real(file, argv);
}

int execvpe(const char *file, char *const argv[], char *const envp[]) {
    static int (*real)(const char *, char *const[], char *const[]);
    if (!real) real = dlsym(RTLD_NEXT, "execvpe");
    return real(file, argv, ensure_path(envp));
}

int posix_spawn(pid_t *pid, const char *path,
                const posix_spawn_file_actions_t *fa,
                const posix_spawnattr_t *attr,
                char *const argv[], char *const envp[]) {
    static int (*real)(pid_t *, const char *,
                       const posix_spawn_file_actions_t *,
                       const posix_spawnattr_t *,
                       char *const[], char *const[]);
    if (!real) real = dlsym(RTLD_NEXT, "posix_spawn");
    return real(pid, path, fa, attr, argv, ensure_path(envp));
}

int posix_spawnp(pid_t *pid, const char *file,
                 const posix_spawn_file_actions_t *fa,
                 const posix_spawnattr_t *attr,
                 char *const argv[], char *const envp[]) {
    static int (*real)(pid_t *, const char *,
                       const posix_spawn_file_actions_t *,
                       const posix_spawnattr_t *,
                       char *const[], char *const[]);
    if (!real) real = dlsym(RTLD_NEXT, "posix_spawnp");
    return real(pid, file, fa, attr, argv, ensure_path(envp));
}
