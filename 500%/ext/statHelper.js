function buildRule(index, name, type) {
    return `
rule "<STAT HELPER> calc pretty stat for '${name}'":
    @Event global
    statDataHelper[${index}] = statsData[${type}]
    statDataHelper[${index + 1}] = 0
    statDataHelper[${index + 2}] = 0

    while statDataHelper[${index + 0}] > 1000:
        statDataHelper[${index}] = statDataHelper[${index + 0}] / 1000
        statDataHelper[${index + 1}]++
        wait()

    statDataHelper[${index + 2}] = "{} {}".format(statDataHelper[${index}], {
        0: "",
        1: "K",
        2: "K",
        2: "K",
        3: "M",
        4: "M",
        5: "M"
    }[statDataHelper[${index + 2}]])

    wait(1)
    goto RULE_START

#!define getFormatted_${name} statDataHelper[${index + 3}]

`
}

count = 1;
baseCode = ``;
code = ``;

for(let key of keys) {
    baseCode += `\t# Sync stat ${key.name} from cache\n`
    baseCode += `\tstatDataHelper[${count + 3}] = statDataHelper[${count + 2}]\n`
    code += '\n' + buildRule(count, key.name, key.type) + '\n';
    count += 4;
}

`
globalvar statDataHelper

rule "<STAT HELPER> Init":
    statDataHelper[0] = " KM"

rule "<STAT HELPER> Sync values":
    @Event global
${baseCode}
    wait(1)
    goto RULE_START

${code}
`