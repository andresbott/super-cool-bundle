# super-cool-bundle

Showcase bundle for **adaptTo() 2026** — a tiny, **deliberately vulnerable** OSGi
bundle used to demonstrate *transitive* dependency detection in SBOM / security
scanning.

It depends on — and embeds as a nested lib — a known-vulnerable release of
SnakeYAML (`org.yaml:snakeyaml:1.30`, **CVE-2022-1471**). Anything that depends
on this bundle inherits the vulnerable dependency transitively, and a byte-level
scanner also finds `snakeyaml-1.30.jar` inside the bundle
(`Bundle-ClassPath: .,snakeyaml-1.30.jar`).

> ⚠️ Demo only. Do not deploy this to a real environment.

## Build locally

```bash
mvn clean package
# -> target/super-cool-bundle-1.0.0.jar   (contains snakeyaml-1.30.jar)
```

## Consume via JitPack (public repo — no tokens)

Push a git **tag** (e.g. `1.0.0`) to GitHub. JitPack builds it on demand from the
tag — no publishing, no signing, and **no token for a public repo**.
[`jitpack.yml`](jitpack.yml) pins JDK 21 (matches the pom's `release` target; bnd 7.3 needs 17+).

In the consumer `pom.xml`:

```xml
<repositories>
  <repository>
    <id>jitpack.io</id>
    <url>https://jitpack.io</url>
  </repository>
</repositories>

<dependency>
  <groupId>com.github.andresbott</groupId>
  <artifactId>super-cool-bundle</artifactId>
  <version>1.0.0</version> <!-- the git tag -->
</dependency>
```

The consumer then gets `org.yaml:snakeyaml:1.30` transitively — the CVE your SBOM
scan should flag.
