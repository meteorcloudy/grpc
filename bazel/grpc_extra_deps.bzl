# Copyright 2021 The gRPC Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Loads the dependencies necessary for the external repositories defined in grpc_deps.bzl."""

load("@com_envoyproxy_protoc_gen_validate//:dependencies.bzl", "go_third_party")
load("@com_google_googleapis//:repository_rules.bzl", "switched_rules_by_language")
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
load("@upb//bazel:workspace_deps.bzl", "upb_deps")

def grpc_extra_deps(ignore_version_differences = False):
    """Loads the extra dependencies.

    These are necessary for using the external repositories defined in
    grpc_deps.bzl. Projects that depend on gRPC as an external repository need
    to call both grpc_deps and grpc_extra_deps, if they have not already loaded
    the extra dependencies. For example, they can do the following in their
    WORKSPACE
    ```
    load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps", "grpc_test_only_deps")
    grpc_deps()

    grpc_test_only_deps()

    load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")

    grpc_extra_deps()
    ```

    Args:
      ignore_version_differences: Plumbed directly to the invocation of
        apple_rules_dependencies.
    """
    protobuf_deps()

    upb_deps()

    googleapis_deps()

def googleapis_deps():
    # Initialize Google APIs with only C++ and Python targets
    switched_rules_by_language(
        name = "com_google_googleapis_imports",
        cc = True,
        grpc = True,
        python = True,
    )

grpc_extra_deps_ext = module_extension(implementation = lambda ctx: googleapis_deps())
