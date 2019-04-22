# Coupage 📚

[![Build Status](https://app.bitrise.io/app/1932ee8bf79dc76a/status.svg?token=N64IYYd5l9Tog0bqfD4sXw)](https://app.bitrise.io/app/1932ee8bf79dc76a)

### Why is it called Coupage?

Confluence Unique Page Generator 📚🤪


---
### 💡 Installing

```sh
$ git clone https://github.com/Kota4822/Coupage.git
$ cd Coupage
$ make
```

#### Make resources directory
```sh
$ cd "outputPath"
$ coupage init
```

#### Resources

```
.coupage
├── templates
│   ├── sample
│   │     ├── page_config.yml
│   │     └── template.tpl
│   └── templateA
│         ├── page_config.yml
│         └── template.tpl
└── user_config.yml
```

- user_config.yml
  - id: `confluence user id`
  - password: `confluence user password`
- .coupage/templates/`templateName`
  - Template name to use. As many as you like.
- `templateName`/page_config.yml
  - url: `target confluence base url`
  - default_space_key: `confluence spaceKey to generate page(optional)`
  - default_ancestors_key: `confluence ancestorsKey to generate page(optional)`
- `templateName`/template.tpl
  - Confluence PageTemplate. ([Confluence REST API examples](https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/?_ga=2.43313312.468710968.1554107983-458628118.1548205503))
  - In the template, write as `{{ReplaceKey}}`. Replacing according to the parameters.
  ```sh
  $ coupage ReplaceKey:Value aaa:bbb ...
  ```

---
### 📚 Usage
#### Generate page
```sh
$ coupage run pageTitle:XXX templateName:XXX
```
- ##### Requied Parameter
  - ##### pageTitle: `page title`
  - ##### templateName: `template name to use`
- ##### Optional Parrameter
  - spaceKey: `spaceKey to output(optional：If not in the parameter, use page_config.yml.)`
  - ancestorsKey: `ancestorsKey to output(optional：If not in the parameter, use page_config.yml.)`
  - template ReplaceKey and Values
