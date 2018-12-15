<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" media-type="text/xml" />
    <xsl:key use="@manufacturer-id" name="manufacturer" match="electronics-shop/data/product-filters/manufacturers/manufacturer"/>
    <xsl:key use="@category-id" name="category" match="electronics-shop/data/product-filters/product-types/product-type"/>
    <!-- Main template -->
    <xsl:template match="/">
        <xsl:element name="electronics-shop">
            <xsl:apply-templates select="electronics-shop/data/products-list" />
            <xsl:call-template name="summary"/>
            <xsl:call-template name="document-information"/>
        </xsl:element>
    </xsl:template>
    <!-- Product list template -->
    <xsl:template match="electronics-shop/data/products-list">
        <xsl:element name="products-list">
            <xsl:apply-templates select="//product"/>
        </xsl:element>
    </xsl:template>
    <!-- Product template -->
    <xsl:template match="//product">
        <xsl:element name="product">
            <xsl:call-template name="product-attributes"/>
            <xsl:call-template name="product-information"/>
        </xsl:element>
    </xsl:template>
    <!-- Product attributes template -->
    <xsl:template name="product-attributes">
        <xsl:attribute name="product-id">
            <xsl:value-of select="@product-id" />
        </xsl:attribute>
        <xsl:attribute name="category">
            <xsl:value-of select="key('category', @category-id)" />
        </xsl:attribute>
        <xsl:attribute name="manufacturer">
            <xsl:value-of select="key('manufacturer', @manufacturer-id)/manufacturer-name"/>
        </xsl:attribute>
    </xsl:template>
    <!-- Product information template -->
    <xsl:template name="product-information">
        <xsl:element name="name">
            <xsl:value-of select="./name"/>
        </xsl:element>
        <xsl:element name="price">
            <xsl:attribute name="currency">
                <xsl:value-of select="./price/@currency"/>
            </xsl:attribute>
            <xsl:value-of select="./price"/>
        </xsl:element>
        <xsl:element name="on-sale">
            <xsl:value-of select="./price/@on-sale"/>
        </xsl:element>
        <xsl:element name="release-date">
            <xsl:for-each select="./release-date/*">
                <xsl:element name="{local-name()}">
                    <xsl:value-of select="current()"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
        <xsl:element name="warranty">
            <xsl:attribute name="time-unit">
                <xsl:value-of select="./warranty/@*" />
            </xsl:attribute>
            <xsl:value-of select="./warranty"/>
        </xsl:element>
        <xsl:element name="specification">
            <xsl:for-each select="./specification/*">
                <xsl:element name="{local-name()}">
                    <xsl:value-of select="current()"/>
                    <xsl:value-of select="current()/@*" />
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
        <xsl:element name="user-rating">
            <xsl:value-of select="./user-rating"/>
        </xsl:element>
        <xsl:element name="in-stock">
            <xsl:value-of select="./in-stock"/>
        </xsl:element>
        <xsl:element name="free-delivery">
            <xsl:value-of select="./free-delivery/@available"/>
        </xsl:element>
        <xsl:element name="additional-information">
            <xsl:value-of select="./additional-information"/>
        </xsl:element>
        <xsl:element name="aggregate-value">
            <xsl:attribute name="currency">
                <xsl:text>pln</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="format-number(./price * ./in-stock, '#')"/>
        </xsl:element>
    </xsl:template>
    <!-- Summary template -->
    <xsl:template name="summary">
        <xsl:element name="summary">
            <xsl:call-template name="total-number-of-different-products"/>
            <xsl:call-template name="total-number-of-products"/>
            <xsl:call-template name="number-of-products-by-manufacturer"/>
            <xsl:call-template name="number-of-products-by-category"/>
            <xsl:call-template name="average-product-price"/>
            <xsl:call-template name="average-product-rating"/>
            <xsl:call-template name="products-with-free-delivery"/>
        </xsl:element>
    </xsl:template>
    <!-- Total number of products -->
    <xsl:template name="total-number-of-different-products">
        <xsl:element name="total-number-of-different-products">
            <xsl:value-of select="count(//product)"/>
        </xsl:element>
    </xsl:template>
    <!-- Total number of all products -->
    <xsl:template name="total-number-of-products">
        <xsl:element name="total-number-of-products">
            <xsl:value-of select="sum(//product/in-stock)"/>
        </xsl:element>
    </xsl:template>
    <!-- Number of products by manufacturer -->
    <xsl:template name="number-of-products-by-manufacturer">
        <xsl:element name="number-of-products-by-manufacturer">
            <xsl:for-each select="electronics-shop/data/product-filters/manufacturers/manufacturer">
                <!-- Ascending sort (from a to z) -->
                <xsl:sort select="@manufacturer-id"/>
                <xsl:element name="number-of-{current()/@manufacturer-id}-products">
                    <xsl:attribute name="manufacturer-name">
                        <xsl:value-of select="//manufacturer[@manufacturer-id = current()/@manufacturer-id]/manufacturer-name"/>
                    </xsl:attribute>
                    <xsl:value-of select="count(//product[@manufacturer-id = current()/@manufacturer-id])"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!-- Number of products by category -->
    <xsl:template name="number-of-products-by-category">
        <xsl:element name="number-of-products-by-category">
            <xsl:for-each select="electronics-shop/data/product-filters/product-types/product-type">
                <!-- Sort from the highest to lowest number of products -->
                <xsl:sort select="count(//product[@category-id = current()/@category-id])" order="descending"/>
                <!-- Avoids grammar mistakes -->
                <xsl:choose>
                    <xsl:when test="current()/@category-id = 'accessory'">
                        <xsl:element name="number-of-accessories">
                            <xsl:attribute name="category-name">
                                <xsl:value-of select="//product-type[@category-id = current()/@category-id]"/>
                            </xsl:attribute>
                            <xsl:value-of select="count(//product[@category-id = current()/@category-id])"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="current()/@category-id = 'mouse'">
                        <xsl:element name="number-of-mice">
                            <xsl:attribute name="category-name">
                                <xsl:value-of select="//product-type[@category-id = current()/@category-id]"/>
                            </xsl:attribute>
                            <xsl:value-of select="count(//product[@category-id = current()/@category-id])"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="number-of-{current()/@category-id}s">
                            <xsl:attribute name="category-name">
                                <xsl:value-of select="//product-type[@category-id = current()/@category-id]"/>
                            </xsl:attribute>
                            <xsl:value-of select="count(//product[@category-id = current()/@category-id])"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!-- Average price of a product -->
    <xsl:template name="average-product-price">
        <xsl:element name="average-product-price">
            <xsl:value-of select="format-number(sum(//product/price) div count(//product),'#.#')"/>
        </xsl:element>
    </xsl:template>
    <!-- Average product rating -->
    <xsl:template name="average-product-rating">
        <xsl:element name="average-product-rating">
            <xsl:value-of select="format-number(sum(//product/user-rating) div count(//product),'#.##')"/>
        </xsl:element>
    </xsl:template>
    <!-- Products with free delivery -->
    <xsl:template name="products-with-free-delivery">
        <xsl:element name="products-with-free-delivery">
            <xsl:for-each select="//product">
                <xsl:if test="current()/free-delivery/@available = 'available'">
                    <xsl:element name="product-name">
                        <xsl:value-of select="current()/name" />
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <!-- Document information template -->
    <xsl:template name="document-information">
        <xsl:element name="document-information">
            <xsl:element name="authors">
                <xsl:for-each select="//author">
                    <xsl:element name="author">
                        <xsl:value-of select="current()"></xsl:value-of>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            <!-- Current date -->
            <!-- This does not work in a browser, because no browser supports XSLT 2.0. To perform the transform, use:
            https://www.freeformatter.com/xsl-transformer.html -->
            <xsl:element name="date-of-the-report">
                <xsl:value-of 
      select="format-date(current-date(), 
              '[FNn], the [D1o] of [MNn], [Y0001]')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
<!-- 
    xsl:element
    <xsl:value-of select=""/>
 -->