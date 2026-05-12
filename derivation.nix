{lib, stdenv, fetchYarnDeps, yarnConfigHook, yarnBuildHook, yarnInstallHook, nodejs_20}:
stdenv.mkDerivation {
	pname = "enketo";
	version = "7.6.1";
	src = ./.;
	yarnOfflineCache = fetchYarnDeps {
		yarnLock = ./yarn.lock;
		hash = "sha256-tT8by1NYznfVSETKYJRdtGeBX98DYPkf4eaXZOptr20=";
	};
	nativeBuildInputs = [
		yarnConfigHook
		yarnBuildHook
		nodejs_20
	];
}
