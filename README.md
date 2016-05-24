# DCOS Repo

This Repo is mostly for alternative Elasticsearch DCOS Applications, but will be my testing area for other Mesos Frameworks

## Installation


If you would like to add this to your DCOS manually:

```
dcos package repo add DCOSRepo https://github.com/rickalm/DCOS-Repo/archive/version-2.x.zip
```


### Content

#### `package.json`

```json
{
  "packagingVersion": "2.0",
  "name": "foo",
  "version": "1.2.3",
  "tags": ["mesosphere", "framework"],
  "maintainer": "help@bar.io",
  "description": "Does baz.",
  "scm": "https://github.com/bar/foo.git",
  "website": "http://bar.io/foo",
  "postInstallNotes": "Have fun foo-ing and baz-ing!"
}
```
_Sample `package.json`._

The required fields are:

- packagingVersion
- name
- version
- tags
- maintainer
- description

#### `config.json`

This file describes the configuration properties supported by the package. Each property can
specify whether or not it is required, a default value, as well as some basic validation.

Users can then [override specific values](https://docs.mesosphere.com/using/cli/packagesyntax/) at
installation time by passing an options file to the DCOS CLI.

```json
{
  "type": "object",
  "properties": {
    "foo": {
      "type": "object",
      "properties": {
        "baz": {
          "type": "integer",
          "description": "How many times to do baz.",
          "minimum": 0,
          "maximum": 16,
          "required": false,
          "default": 4
        }
      },
      "required": ["baz"]
    }
  },
  "required": ["foo"]
}
```
_Sample `config.json`._

`config.json` must be a valid [JSON Schema](http://json-schema.org/) file. Check out the
[JSON Schema examples](http://json-schema.org/examples.html).

#### `marathon.json.mustache`

This file describes how to run the package as a
[Marathon](http://github.com/mesosphere/marathon) app.

User-supplied metadata (as described in `config.json`), the defaults from `config.json` and the
resource information in `resource.json` will be injected to the template using
[mustache template](http://mustache.github.io/) syntax.

```json
{
  "id": "foo",
  "cpus": "1.0",
  "mem": "1024",
  "instances": "1",
  "args": ["{{{foo.baz}}}"],
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "{{resource.assets.container.docker.foo23b1cfe8e04a}}",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 0,
          "servicePort": 0,
          "protocol": "tcp"
        }
      ]
    }
  }
}
```
_Sample `marathon.json.mustache`._

See the
[Marathon API Documentation](https://mesosphere.github.io/marathon/docs/rest-api.html)
for more detailed instruction on app definitions.

#### `command.json`

This file is **optional**. Describes how to install the package's CLI.
Currently the only supported format is a Pip requirements file where each
element in the array is a line in the requirements file.

```json
{
  "pip": [
    "https://pypi.python.org/packages/source/f/foo/foo-1.2.3.tar.gz"
  ]
}
```
_Sample `command.json`._

See the [Command Schema](repo/meta/schema/command-schema.json) for a detailed description of
the schema.

#### `resource.json`

This file contains all of the externally hosted resources (E.g. Docker images, HTTP objects and
images) needed to install the application.

```json
{
  "images": {
    "icon-small": "http://some.org/foo/small.png",
    "icon-medium": "http://some.org/foo/medium.png",
    "icon-large": "http://some.org/foo/large.png",
    "screenshots": [
      "http://some.org/foo/screen-1.png",
      "http://some.org/foo/screen-2.png"
    ]
  },
  "assets": {
    "uris": {
      "log4j-properties": "http://some.org/foo/log4j.properties"
    },
    "container": {
      "docker": {
        "23b1cfe8e04a": "some-org/foo:1.0.0"
      }
    }
  }
}
```
_Sample `resource.json`._

For the Docker image, please use the image ID for the referenced image. You can find this by
pulling the image locally and running `docker images some-org/foo:1.0.0`.

While `images` is an optional field, it is highly recommended you include icons and screenshots
in your package and update the path definitions accordingly. Specifications are as follows:

* `icon-small`: 48px (w) x 48px (h)
* `icon-medium`: 96px (w) x 96px (h)
* `icon-large`: 256px (w) x 256px (h)
* `screenshots[...]`: 1200px (w) x 675px (h)

**NOTE:** To ensure your service icons look beautiful on retina-ready displays,
please supply 2x versions of all icons. No changes are needed to
`package.json` - simply supply an additional icon file with the text `@2x` in
the name before the file extension.
For example, the icon `icon-cassandra-small.png` would have a retina-ready
alternate image named `icon-cassandra-small@2x.png`.

### Versioning

The registry specification is versioned separately in the file `/repo/meta/version.json`.

```json
{
  "version": "2.0.0-rc2"
}
```
_Sample `repo/meta/version.json`._

This version is updated with any change to the required file content
(typically validated using JSON schema) or expected file organization in the
`repo` directory.

_NOTE: The current version is `2.0.0-rc2` to facilitate rapid
iteration.  This version will be fixed and incremented as
described above as programs that consume the format reach maturity._

The packaging version should also be included in the `package.json` for each package using the
`packagingVersion` property.

### Validation

Package content is validated using [JSON Schema](http://json-schema.org).
The schema definitions live in `/repo/meta/schema`.

## Directory Structure

```
├── LICENSE
├── README.md
├── docs
│   ├── best-practices.md
│   └── contributing.md
├── hooks
│   └── pre-commit
├── repo
│   ├── meta
│   │   ├── index.json
│   │   ├── schema
│   │   │   ├── command-schema.json
│   │   │   ├── config-schema.json
│   │   │   ├── index-schema.json
│   │   │   ├── resource-schema.json
│   │   │   └── package-schema.json
│   │   └── version.json
│   └── packages
│       ├── B
│       │   ├── bar
│       │   │   ├── 0
│       │   │   │   ├── command.json
│       │   │   │   ├── config.json
│       │   │   │   ├── marathon.json.mustache
│       │   │   │   ├── resource.json
│       │   │   │   └── package.json
│       │   │   └── ...
│       │   └── ...
│       ├── F
│       │   ├── foo
│       │   │   ├── 0
│       │   │   │   ├── config.json
│       │   │   │   ├── marathon.json.mustache
│       │   │   │   ├── resource.json
│       │   │   │   └── package.json
│       │   │   └── ...
│       │   └── ...
│       └── ...
└── scripts
    ├── 1-validate-packages.sh
    ├── 2-build-index.sh
    ├── 3-validate-index.sh
    ├── 4-detect-dependency-cycles.sh
    ├── build.sh
    └── install-git-hooks.sh
```

## Sources and Transfer Protocols

This section describes transfer of package metadata from a universe source to a client program.

```
 ┌───────────────┐   ┌────────────────┐
 │public universe│   │private universe│
 └───────────────┘   └────────────────┘
         http \         / http
               \       /
                \     /
               ┌────┐           ┌────────┐
               │DCOS│-----------│Marathon│
               └────┘    http   └────────┘
```
_Sample (simplified) architecture for a universe client program._

Package sources are described as URLs.

Source URLs encode the transfer protocol. Recommendations for several transfer protocols follow.

**HTTP and HTTPS**

A URL that designates a
[zip](http://en.wikipedia.org/wiki/Zip_%28file_format%29) file
accessible over HTTP or HTTPS with media type `application/zip`.
Example: `http://my.org/files/universe/packages.zip`
