# super-cool-bundle

Showcase bundle for **adaptTo() 2026** — a tiny OSGi bundle used to demonstrate
*transitive* dependency detection in SBOM / security scanning.

**Version `2.0.0` is the remediated release.** It depends on — and embeds as a
nested lib — a **non-vulnerable** release of SnakeYAML
(`org.yaml:snakeyaml:2.4`), which fixes **CVE-2022-1471**. Anything that depends
on this bundle now inherits a clean dependency transitively, and a byte-level
scanner finds `snakeyaml-2.4.jar` inside the bundle
(`Bundle-ClassPath: .,snakeyaml-2.4.jar`) — so an SBOM / security scan comes back
clean.

> The earlier `1.0.0` release was **deliberately vulnerable** (it shipped
> `snakeyaml:1.30`, CVE-2022-1471) so a scan would flag it. `2.0.0` is the
> "after remediation" counterpart.

> ⚠️ Demo only. Do not deploy this to a real environment.

## Build locally

```bash
mvn clean package
# -> target/super-cool-bundle-2.0.0.jar   (contains snakeyaml-2.4.jar)
```

## Consume via JitPack (public repo — no tokens)

Push a git **tag** (e.g. `2.0.0`) to GitHub. JitPack builds it on demand from the
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
  <version>2.0.0</version> <!-- the git tag -->
</dependency>
```

The consumer then gets `org.yaml:snakeyaml:2.4` transitively — the remediated,
non-vulnerable version, so your SBOM scan comes back clean.
