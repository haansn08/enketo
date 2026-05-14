{lib, stdenv, fetchzip, fetchurl, fetchYarnDeps, yarnConfigHook, yarnBuildHook, yarnInstallHook, nodejs, python3, python3Packages, nodePackages, sass}:
stdenv.mkDerivation (finalAttrs: {
	pname = "enketo";
	version = "7.6.1";
	src = fetchzip {
		url = "https://github.com/enketo/enketo/archive/refs/tags/${finalAttrs.version}.tar.gz";
		hash = "sha256-qls3SYrz7JqIAdUHGojny6gedt5CIaMie918cw4tPio=";
	};
	yarnOfflineCache = fetchYarnDeps {
		yarnLock = finalAttrs.src + "/yarn.lock";
		hash = "sha256-XEzgF30p1PkejdRBXIucWxRwrMReHyuazgyaxR6bpk4=";
	};
	yarnBuildScript = "install";
	yarnBuildFlags = "--offline --frozen-lockfile";
	postBuildHook = "yarn cache clean";
	
	PUPPETEER_SKIP_DOWNLOAD = "1";
	#SKIP_SASS_BINARY_DOWNLOAD_FOR_CI = "1";
	SASS_BINARY_NAME = "${sass}/bin/sass";
	#npm_package_config_node_gyp_tarball = fetchurl {
	#	url = "https://nodejs.org/download/release/v22.22.2/node-v22.22.2-headers.tar.gz";
	#	hash = "sha256-kOXvD98C+ISH+QSnmINrNb1EiWBG1QKHO8YlrCuu3tI=";
	#};
	#node_gyp_silly = "1";
	
	nativeBuildInputs = [
		yarnConfigHook
		yarnBuildHook
		yarnInstallHook
		nodejs
		python3
		python3Packages.distutils
		sass
	];
})
