dd_ValidateCommand:
    debug: false
    type: command
    name: ddValidate
    description: Admin - Validate dDungeon Configuration and Files
    usage: /ddValidate
    permission: ops
    permission message: <bold><red>*** You're not authorized to do that ***
    script:
    - run dd_ValidateConfigs