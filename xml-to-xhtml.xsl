<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="electronics-shop">
        <html>
            <body>
                <table border="1">
                    <tr>
                        <th>Name</th>
                        <th>Price</th>
                        <th>On sale</th>
                        <th>Release date</th>
                        <th>Warranty</th>
                        <th>Weight</th>
                        <th>Display Size</th>
                        <th>Color</th>
                        <th>User rating</th>
                        <th>In stock</th>
                        <th>Free delivery</th>
                        <th>Additional information</th>
                        <th>Aggregate value</th>
                    </tr>
                    <xsl:for-each select="products-list/product">
                        <tr>
                            <xsl:for-each select="./*">
                                <td>
                                    <xsl:value-of select="."/>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </table>

                <h1>Supporting XML Summary</h1>
                <h2>Authors</h2>
                <ul>
                    <xsl:for-each select="document-information/authors/author">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
                <p>
                    Total number of products composed of
                    <xsl:value-of select="summary/total-number-of-different-products"/> different products is
                    <xsl:value-of select="summary/total-number-of-products"/>.
                </p>
                <h2>Number of products by manfacturer</h2>
                <xsl:for-each select="summary/number-of-products-by-manufacturer">
                    <ul>
                        <li>
                            Acer : <xsl:value-of select="number-of-acer-products"/>
                        </li>
                        <li>
                            Apple : <xsl:value-of select="number-of-acer-products"/>
                        </li>
                    </ul>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>