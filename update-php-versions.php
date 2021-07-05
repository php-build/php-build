<?php

/*
 *
 *  ____            _        _   __  __ _                  __  __ ____
 * |  _ \ ___   ___| | _____| |_|  \/  (_)_ __   ___      |  \/  |  _ \
 * | |_) / _ \ / __| |/ / _ \ __| |\/| | | '_ \ / _ \_____| |\/| | |_) |
 * |  __/ (_) | (__|   <  __/ |_| |  | | | | | |  __/_____| |  | |  __/
 * |_|   \___/ \___|_|\_\___|\__|_|  |_|_|_| |_|\___|     |_|  |_|_|
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * @author PocketMine Team
 * @link http://www.pocketmine.net/
 *
 *
*/

declare(strict_types=1);

const VERSIONS = [
	"7.3",
	"7.4",
	"8.0"
];

$travisYml = file_get_contents(__DIR__ . '/.travis.yml');
$newTravisYml = $travisYml;
$githubWorkflowYml = file_get_contents(__DIR__ . '/.github/workflows/ci.yml');
$newGithubWorkflowYml = $githubWorkflowYml;
$runTestsSh = file_get_contents(__DIR__ . '/run-tests.sh');
$newRunTestsSh = $runTestsSh;
$changelogMd = file_get_contents(__DIR__ . '/CHANGELOG.md');
$newChangelogMd = $changelogMd;

foreach(VERSIONS as $v){
	$releaseInfo = file_get_contents("https://secure.php.net/releases?json&version=$v");
	if($releaseInfo === false){
		throw new \RuntimeException("Failed to contact php.net API");
	}
	$data = json_decode($releaseInfo, true);
	if(!is_array($data) || !isset($data["version"]) || !is_string($data["version"]) || preg_match('/^(\d+)\.(\d+)\.(\d+)(-[A-Za-z\d]+)?$/', $data["version"], $parts) === 0){
		throw new \RuntimeException("Invalid data returned by API");
	}

	$newTravisYml = preg_replace('/(*ANYCRLF)^(\s*env: DEFINITION=)' . preg_quote($v) . '\.\d+$/m', '${1}' . $data["version"], $newTravisYml);
	$newGithubWorkflowYml = preg_replace('#(*ANYCRLF)^(\s*- \')' . preg_quote($v) . '\.\d+\'$#m', '${1}' . $data["version"] . '\'', $newGithubWorkflowYml);
	$newRunTestsSh = preg_replace('/(*ANYCRLF)^(STABLE_DEFINITIONS=".*)' . preg_quote($v) . '\.\d+(.*")$/m','${1}' . $data["version"] . '${2}', $newRunTestsSh);

	$newDefFile = __DIR__ . '/share/php-build/definitions/' . $data["version"];
	if(!file_exists($newDefFile)){
		$majorVersion = (int) $parts[1];
		$minorVersion = (int) $parts[2];
		$patchVersion = (int) $parts[3];
		$defToCopy = null;
		for($i = $patchVersion; $i >= 0; $i--){
			$file = __DIR__ . "/share/php-build/definitions/$majorVersion.$minorVersion.$i";
			if(file_exists($file)){
				echo "Copying definition for $majorVersion.$minorVersion.$i for " . $data["version"] . "\n";
				$contents = file_get_contents($file);
				file_put_contents($newDefFile, str_replace("php-$majorVersion.$minorVersion.$i", "php-" . $data["version"], $contents));

				if(preg_match('/(*ANYCRLF)^(\* Added PHP ' . preg_quote($v) . ' definitions?: .*)`' . $data["version"] . '`(.*)$/m', $newChangelogMd) === 0){
					echo "Updating changelog to add note for " . $data["version"] . "\n";
					$newChangelogMd = preg_replace($pattern = '/(*ANYCRLF)^(\* Added PHP ' . preg_quote($v) . ' definitions?: .*)$/m', '${1}, `' . $data["version"] . '`', $newChangelogMd);
				}
				continue 2;
			}
		}
		echo "ERROR: No baseline definition could be duplicated for " . $data["version"] . "; you may need to write one manually\n";
	}
}


if($travisYml !== $newTravisYml){
	echo "Writing modified travis.yml\n";
	file_put_contents(__DIR__ . '/.travis.yml', $newTravisYml);
}
if($newGithubWorkflowYml !== $githubWorkflowYml){
	echo "Writing modified .github/workflows/ci.yml\n";
	file_put_contents(__DIR__ . '/.github/workflows/ci.yml', $newGithubWorkflowYml);
}
if($newRunTestsSh !== $runTestsSh){
	echo "Writing modified run-tests.sh\n";
	file_put_contents(__DIR__ . '/run-tests.sh', $newRunTestsSh);
}
if($newChangelogMd !== $changelogMd){
	echo "Writing modified CHANGELOG.md\n";
	file_put_contents(__DIR__ . '/CHANGELOG.md', $newChangelogMd);
}
