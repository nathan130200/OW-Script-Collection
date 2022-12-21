`
${variable} = -1
while ${variable} < len(${array}) - 1:
    #!define loopBody_${key} ${array}[${variable}]
    #!define loopIndex${key} ${variable}
    ${variable}++
`