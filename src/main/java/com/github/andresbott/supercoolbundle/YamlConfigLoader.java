package com.github.andresbott.supercoolbundle;

import java.io.StringReader;

import org.yaml.snakeyaml.Yaml;

/**
 * Minimal YAML helper backed by SnakeYAML.
 *
 * <p>This class exists only so that {@code org.yaml:snakeyaml:2.4} (the release
 * that fixes CVE-2022-1471) is a genuine compile dependency of this bundle, and
 * therefore a transitive dependency of anything that depends on it. It is a
 * fixture for exercising SBOM / security scanning and is <strong>not</strong>
 * intended for production use.</p>
 */
public class YamlConfigLoader {

    private final Yaml yaml = new Yaml();

    /**
     * Parses a YAML document using the non-vulnerable SnakeYAML release.
     *
     * @param yamlSource the YAML text to parse
     * @return the parsed object graph
     */
    public Object load(String yamlSource) {
        return yaml.load(new StringReader(yamlSource));
    }
}
