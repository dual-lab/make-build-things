import urllib.request
from urllib.error import HTTPError
import sys
import os
import json

"""
Author: dmike
Main script that comunicat with github using the v3 api.
"""


def makeARequest(end_point, payload=None, headers={}, method='GET'):
    auth_header = {
        'Authorization': 'token ' + os.environ['GITHUB_TOKEN']
    }
    headers.update(auth_header)
    return urllib.request.Request(url=end_point, data=payload, headers=headers, method=method)


def checkTag(url):
    request = makeARequest(end_point=url)
    try:
        with urllib.request.urlopen(request) as response:
            assert response.getcode() == 404
    except HTTPError as he:
        assert he.getcode() == 404


def createRelease(url, tag, name, description):
    data = json.dumps({
        "tag_name": tag,
        "name": name,
        "body": description,
        "draft": True,
        "prerelease": True})
    request = makeARequest(end_point=url, headers={
                           'Content-Type': 'Application/json'}, method='POST', payload=bytes(data, 'ascii'))
    with urllib.request.urlopen(request) as response:
        assert response.getcode() == 201
        body = json.loads(response.read())
        return body['upload_url']


def extractChangelog(version):
    changes = list()
    marker = '## ['+version+']'
    with open('CHANGELOG.md', 'r') as changelog:
        start_recording = False
        for line in changelog:
            if start_recording:
                if line.startswith('## '):
                    break
                changes.append(line)
            else:
                start_recording = line.startswith(marker)
    return changes


def uploadArtifact(url, name):
    try:
        tar_gz = open(name+'.tar.gz', 'rb')
        content = tar_gz.read()
        request = makeARequest(end_point=url, headers={
                               'Content-Type': 'Application/zip'}, method='POST', payload=content)
        with urllib.request.urlopen(request) as response:
            assert response.getcode() == 201
    finally:
        tar_gz.close()


if __name__ == "__main__":
    assert len(
        sys.argv) > 3, "The script must recive tre argument as input: [tag,version,artifactif]"

    print("+ Start publish script")
    tag = sys.argv[1]
    version = sys.argv[2]
    artifactid = sys.argv[3]
    github_endpoint = 'https://api.github.com/repos'

    print("+ check if the tag already exists")
    checkTag(github_endpoint+"/dual-lab/make-build-things/releases/tags/"+tag)

    print("+ create release")
    upload_url = createRelease(github_endpoint +
                               "/dual-lab/make-build-things/releases", tag, artifactid, ''.join(extractChangelog(version)))
    upload_url = upload_url.replace('{?name,label}', '?name='+artifactid+'.tar.gz')

    print("+ upload artifactd")
    uploadArtifact(upload_url, artifactid)
