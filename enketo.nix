{lib, stdenv, fetchzip, fetchurl, yarn, fetchYarnDeps, yarnConfigHook, yarnBuildHook, yarnInstallHook, nodejs, python3, python3Packages, nodePackages, sass, node-gyp}:
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
	
	PUPPETEER_SKIP_DOWNLOAD = "1";
	SASS_BINARY_NAME = "${sass}/bin/sass";
	
	buildPhase = ''
		runHook preBuild
		set -x

		export HOME=$(mktemp -d)
		yarn config --offline set yarn-offline-mirror ${finalAttrs.yarnOfflineCache}
		# Without this, yarn will try to download the dependencies
		fixup-yarn-lock yarn.lock

		# set nodedir to prevent node-gyp from downloading headers
		export npm_config_nodedir=${nodejs}
		
		yarn --offline --frozen-lockfile workspace enketo-transformer build
		yarn --offline --frozen-lockfile workspace openrosa-xpath-evaluator build
		yarn --offline --frozen-lockfile workspace enketo-core install
		yarn --offline --frozen-lockfile workspace enketo-core build
		yarn --offline --frozen-lockfile workspace enketo-express build
		
		set +x
		runHook postBuild
  	'';
	postBuildHook = "yarn cache clean";
	
	installPhase = ''
		runHook preInstall
		set -x
		
		mkdir -p $out/bin/enketo
		cp -r node_modules packages  $out/bin/enketo
		
		set +x
		runHook postInstall
  	'';
	
	buildInputs = [
		nodejs
	];
	
	nativeBuildInputs = [
		yarnConfigHook
		nodejs node-gyp nodePackages.grunt-cli
		python3 python3Packages.distutils sass
	];
})
