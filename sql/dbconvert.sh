curl -F files[]=@sp500.sql 'https://www.rebasedata.com/api/v1/convert?outputFormat=sqlite&errorResponse=zip' -o sp500.sqlite.zip
unzip sp500.sqlite.zip && mv data.sqlite sp500.sqlite && rm sp500.sqlite.zip
