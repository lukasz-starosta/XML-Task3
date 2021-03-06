<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="utf-8"
doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
/>
    <xsl:template match="electronics-shop">
        <html
            xmlns="http://www.w3.org/1999/xhtml"
            lang="en"
            xml:lang="en">
            <head>
                <title>XML Task 3 217862 217846</title>
            </head>
            <body style="font-family: sans-serif;">
                <div>
                    <h2>Authors</h2>
                    <ul>
                        <xsl:for-each select="document-information/authors/author">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                    <h4>Date of the report:</h4>
                    <p>
                        <xsl:value-of select="document-information/date-of-the-report" />
                    </p>
                </div>
                <div>
                    <h2>Products</h2>
                    <table border="1">
                        <thead style="background: lightblue">
                            <tr>
                                <th>Name</th>
                                <th>Price</th>
                                <th>On sale</th>
                                <th>Release date</th>
                                <th>Warranty</th>
                                <th>Specification</th>
                                <th>User rating</th>
                                <th>In stock</th>
                                <th>Free delivery</th>
                                <th>Additional information</th>
                                <th>Aggregate value</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="products-list/product">
                                <tr>
                                    <xsl:for-each select="./*">
                                        <xsl:choose>
                                            <!-- Availability colors -->
                                            <xsl:when test="name() = 'free-delivery'">
                                                <xsl:choose>
                                                    <xsl:when test="current() = 'available'">
                                                        <td style="background: lightgreen">
                                                            <xsl:value-of select="."/>
                                                        </td>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <td style="background: lightcoral">
                                                            <xsl:value-of select="."/>
                                                        </td>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="name() = 'additional-information'">
                                                <td>
                                                    <xsl:value-of select="."/>
                                                    <xsl:if test="current() = ''">
                                                        <i>None</i>
                                                    </xsl:if>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>
                                                    <xsl:value-of select="."/>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
                <div>
                    <h2>Supporting XML Summary</h2>
                    <ul>
                        <li>
                            <p>
                                <i>Total number of different products - </i>
                                <xsl:value-of select="summary/total-number-of-different-products"/>
                            </p>
                        </li>
                        <li>
                            <p>
                                <i>Total number of products in stock - </i>
                                <xsl:value-of select="summary/total-number-of-products"/>
                            </p>
                        </li>
                        <li>
                            <i>Number of products by manufacturer:</i>
                            <p>
                                <xsl:for-each select="summary/number-of-products-by-manufacturer/*">
                                    <em>
                                        <xsl:value-of select="current()/@manufacturer-name"/> -
                                    </em>
                                    <xsl:value-of select="."/>
                                    <br/>
                                </xsl:for-each>
                            </p>
                        </li>
                        <li>
                            <i>Number of products by category:</i>
                            <p>
                                <xsl:for-each select="summary/number-of-products-by-category/*">
                                    <em>
                                        <xsl:value-of select="current()/@category-name"/> -
                                    </em>
                                    <xsl:value-of select="."/>
                                    <br/>
                                </xsl:for-each>
                            </p>
                        </li>
                        <li>
                            <p>
                                <i>Average product price - </i>
                                <xsl:value-of select="summary/average-product-price"/>
                            </p>
                        </li>
                        <li>
                            <p>
                                <i>Average product rating - </i>
                                <xsl:value-of select="summary/average-product-rating"/>
                            </p>
                        </li>
                        <li>
                            <h4>
                                <i>Products with free delivery:</i>
                            </h4>
                            <p>
                                <xsl:for-each select="summary/products-with-free-delivery/*">
                                    <strong style="color: lightgreen">
                                        <xsl:value-of select="."/>
                                    </strong>
                                    <br/>
                                </xsl:for-each>
                            </p>
                        </li>
                    </ul>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>