import github
import requests
import platform
import zipfile
import os
from io import BytesIO


def release(version):
    url = "https://api.github.com"
    headers = {
        'Authorization': "token " + os.getenv("GH_TOKEN")}
    g = github.Github(os.getenv("GH_TOKEN"))

    repo = g.get_repo("doksuri761/lcqm")

    release = repo.create_git_release(
        tag=version,
        name=version,
        message=version
    )
    ids = requests.get(url + "/repos/doksuri761/lcqm/actions/artifacts", headers=headers).json()['artifacts'][0]['id']
    artifact = requests.get(url + f"/repos/doksuri761/lcqm/actions/artifacts/{ids}/zip",
                            headers=headers)
    tempfolder = os.getenv("TMP") + "\\lcqm" if platform.system() == "Windows" else "/tmp/lcqm"
    os.mkdir(tempfolder)
    with zipfile.ZipFile(BytesIO(artifact.content), 'r') as zip_file:
        zip_file.extractall(tempfolder)
        release.upload_asset(content_type='application/vnd.android.package-archive', name=f'{version}.apk',
                             path=tempfolder + ("\\" if platform.system() == "Windows" else "/") + "app-release.apk")
    os.unlink(tempfolder + ("\\" if platform.system() == "Windows" else "/") + "app-release.apk")
    os.rmdir(tempfolder)


if __name__ == '__main__':
    release("v1.0.8")
