
## Chakra next from the scratch

### Preprar l'entorn
```
mkdir nextrip
cd nextrip
yarn init -y
yarn add react react-dom next
yarn add @chakra-ui/core @emotion/core @emotion/styled emotion-theming
mkdir pages
```
### Preparem fitxer package.json
```
...
  "scripts": {
    "dev": "next",
    "build": "next build",
    "export": "next export",
    "deploy": "npm run build && npm run export",
    "start": "next start"
  },
...
```

### Crear el fitxer de theme.js
```
echo > theme.js << "EOF"
import { theme as chakraTheme } from '@chakra-ui/core'

const fonts =   {
  body: "'Roboto Slab', seri",
  heading: "'Bebas Neue', serif",
  mono: "Menlo, monospace",
}

const breakpoints = ['450px', '769px', '1080px']

const theme = {
  ...chakraTheme,
  colors: {
    ...chakraTheme.colors,
    black: '#000',
  },
  fonts,
  fontWeights: {
    normal: 300,
    medium: 400,
    bold: 600,
    black: 900,
  },
  fontSizes: {
    xs: "10px",
    sm: "12px",
    md: "14px",
    normal: "16px",
    lg: "18px",
    xl: "24px",
    xxl: "28px",
    xxxl: "32px",
    slidermbl: "40px",
    lemaVid: "45px",
    sizemenu: "50px",
    big: "50px",
    huge: "80px",
  },
  breakpoints,
  icons: {
    ...chakraTheme.icons
  }
}

export default theme
EOF
```

### Crema l'encasulació de l'app
```
cat > pages/_app.js << "EOF"
import NextApp from 'next/app'
import { ThemeProvider, CSSReset, ColorModeProvider } from '@chakra-ui/core'
import theme from '../theme'
import '../assets/css/fonts.css'; /* Optional */



class App extends NextApp {
  render() {
    const { Component, pageProps } = this.props
    return (
      <ThemeProvider theme={theme}>
        <ColorModeProvider>
          <CSSReset />
          <Component {...pageProps} />
        </ColorModeProvider>
      </ThemeProvider>
    )
  }
}

export default App
EOF
```

### Creem fitxer de fonts (opcional)
```
mkdir assets
mkdir assets/css
cat > assets/css/fonts.css <<"EOF"
@import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Roboto&family=Roboto+Slab&display=swap');
EOF
```
### Ja podem crear pagines.
```
cat > pages/index.js << "EOF"
import { withTheme } from 'emotion-theming'
import { Box, Heading, Input, Button, Text } from '@chakra-ui/core'

function IndexPage() {
    return (
            <Box>
                <Text>
                  Hola Mon!  
                </Text>
            </Box>
    )
}
export default IndexPage
EOF
```
