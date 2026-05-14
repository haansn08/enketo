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
	postConfigure = "set -x";
	
	preBuild = ''
		mkdir -p $HOME/.node-gyp/${nodejs.version}
		echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
		ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
		export npm_config_nodedir=${nodejs}
		
		yarn --offline --frozen-lockfile workspace enketo-core install
  	'';
	
	PUPPETEER_SKIP_DOWNLOAD = "1";
	SASS_BINARY_NAME = "${sass}/bin/sass";
		
	buildInputs = [
		nodejs
	];
	
	nativeBuildInputs = [
		yarnConfigHook
		yarnBuildHook
		yarnInstallHook
		nodejs node-gyp nodePackages.grunt-cli
		python3 python3Packages.distutils sass
	];
})
