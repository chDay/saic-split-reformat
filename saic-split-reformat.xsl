<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Replace Filename with the metadata element that holds your local identifier or another unique element. Replace metadata/record with the path that leads to a single record. If using Oxygen for transformation use Saxon-EE 9.6.0.5 for Transformer. -->
    <xsl:template match="record">
        <xsl:param name="identifier_file" select="identifier[@type='local']"/>
        
        <xsl:result-document method="xml" href="{normalize-space($identifier_file)}.xml" encoding="UTF-8" indent="yes">
            
            <mods xmlns="http://www.loc.gov/mods/v3"
                xmlns:etd="http://www.ndltd.org/standards/metadata/etd-ms-v1.1.html"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                
                <xsl:call-template name="record"/>
                
            </mods>
            
        </xsl:result-document>
        
    </xsl:template>
    
    <!-- ITEM RECORD -->
    <xsl:template name="record">
        
        <identifier type="accession"><xsl:value-of select="identifier[@type='accession']"/></identifier>
        <identifier type="local"><xsl:value-of select="identifier[@type='local']"/></identifier>
 
        <!-- TITLEINFO -->
 
        <xsl:apply-templates select="titleInfo"/>       
         
        <!-- NAMES -->
        
        <xsl:apply-templates select="name"/>
        
        <xsl:apply-templates select="contributors"/>
        <xsl:apply-templates select="contributorscorporate"/>
        
        <!-- ORIGININFO -->
        <xsl:apply-templates select="originInfo"/>

        <xsl:apply-templates select="identifier"/>
        
        <xsl:apply-templates select="language"/>
        

        <xsl:if test="abstract!='*'">
            <abstract><xsl:value-of select="abstract"/></abstract>
        </xsl:if>
        
        
        <xsl:apply-templates select="physicalDescription"/>
 
        
        <xsl:for-each select="location">
            <xsl:if test="location!='*'">
            <holdingSimple>
                <copyInformation>
                    <shelfLocator><xsl:value-of select="location"/></shelfLocator>
                </copyInformation>
            </holdingSimple>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="OtherFormatURL">

                <relatedItem type="otherFormat">
                    <location>
                        <url><xsl:value-of select="."/></url>
                    </location>
                </relatedItem>
            
        </xsl:for-each>
        
        <xsl:for-each select="subjectName">
            <xsl:for-each select="tokenize(current(), '\| ')">
                <subject>
                    <name type="personal">
                        <namePart>
                            <xsl:value-of select="."/>
                        </namePart>
                    </name>
                </subject>
            </xsl:for-each>
        </xsl:for-each>
        
        <xsl:for-each select="lcsh">
            <subject authority="lcsh">
                <xsl:for-each select="tokenize(current(), '\| ')">
                    
                    <topic><xsl:value-of select="."/></topic>
                    
                </xsl:for-each>
            </subject>    
        </xsl:for-each>
        
        <xsl:for-each select="trctemp">
            <subject authority="trctemp">
                <xsl:for-each select="tokenize(current(), '\| ')">
                    
                    <topic><xsl:value-of select="."/></topic>
                    
                </xsl:for-each>
            </subject>    
        </xsl:for-each>
        
        <xsl:for-each select="subjectLocal">
            <subject authority="local">
                <xsl:for-each select="tokenize(current(), '\| ')">
                    
                    <topic><xsl:value-of select="."/></topic>
                    
                </xsl:for-each>
            </subject>    
        </xsl:for-each>
        
        
        <xsl:for-each select="note">
            <xsl:if test="@type='local'">
            <note type="local"><xsl:value-of select="."/></note>            
            </xsl:if>
            <xsl:if test="type='accompanyingmaterials'">
            <note type="accompanyingmaterials"><xsl:value-of select="."/></note>   
        </xsl:if>
        <xsl:if test="type='administrative'">
            <note type="administrative"><xsl:value-of select="."/></note>
        </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="typeOfResource">
            <typeOfResource><xsl:value-of select="."/></typeOfResource>
        </xsl:for-each>
        
        <xsl:apply-templates select="genre"/>
        
        <xsl:for-each select="note[@type='administrative']">
            <note type="administrative"><xsl:value-of select="."/></note>
        </xsl:for-each>
        <xsl:for-each select="accessCondition[@type='access restriction']">
            <accessCondition type="access restriction"><xsl:value-of select="."/></accessCondition>
        </xsl:for-each>
        <xsl:for-each select="note[@type='digitization specifications']">
            <note type="digitization specifications"><xsl:value-of select="."/></note>
        </xsl:for-each>
        <xsl:for-each select="accessCondition[@type='use and reproduction']">
            <accessCondition type="use and reproduction"><xsl:value-of select="."/></accessCondition>
        </xsl:for-each>

       
    </xsl:template>   
    
    <!-- End Item Record Template -->
    
    <!-- SUBTEMPLATES -->

    <!-- CREATORS AND CONTRIBUTORS -->

    <xsl:template match="name">
        <xsl:choose>
            <xsl:when test="./creator!=''">
                <name type="personal">
                    <namePart>
                        <xsl:value-of select="./creator"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" authority="marcrelator">Creator</roleTerm>
                    </role>
                </name>
                <xsl:if test="./corporate!=''">
                    <name type="corporate">
                        <namePart>
                            <xsl:value-of select="./corporate"/>
                        </namePart>
                        <role>
                            <roleTerm type="text" authority="marcrelator">Contributor</roleTerm>
                        </role>
                    </name>
                </xsl:if>
            </xsl:when>
            <xsl:when test="./author!=''">
                <name type="personal">
                    <namePart>
                        <xsl:value-of select="./author"/>
                    </namePart>
                    <role>
                        <roleTerm type="text" authority="marcrelator">Author</roleTerm>
                    </role>
                </name>
                <xsl:if test="./corporate!=''">
                    <name type="corporate">
                        <namePart>
                            <xsl:value-of select="./corporate"/>
                        </namePart>
                        <role>
                            <roleTerm type="text" authority="marcrelator">Contributor</roleTerm>
                        </role>
                    </name>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="./corporate!=''">
                    <name type="corporate">
                        <namePart>
                            <xsl:value-of select="./corporate"/>
                        </namePart>
                        <role>
                            <roleTerm type="text" authority="marcrelator">Creator</roleTerm>
                        </role>
                    </name>
                </xsl:if> 
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="role">
        <xsl:for-each select="roleTerm">
            <role>
                <roleTerm type="text" authority="marcrelator">
                    <xsl:value-of select="."/>
                </roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="contributors">
        <xsl:for-each select="tokenize(current(), '\| ')">
            <name type="personal">
                <namePart>
                    <xsl:value-of select="."/> 
                </namePart>
                <role>
                    <roleTerm type="text" authority="marcrelator">Contributor</roleTerm>
                </role>
                <affiliation/>
            </name>
        </xsl:for-each>    
    </xsl:template>

    <xsl:template match="contributorscorporate">
        <xsl:for-each select="tokenize(current(), '\| ')">
            <name type="corporate">
                <namePart>
                    <xsl:value-of select="."/> 
                </namePart>
                <role>
                    <roleTerm type="text" authority="marcrelator">Contributor</roleTerm>
                </role>
                <affiliation/>
            </name>
        </xsl:for-each>    
    </xsl:template>
    

    <xsl:template match="titleInfo">
        
            <xsl:choose>
                <xsl:when test="@type='alternative'">
                    <xsl:if test="./title!=''">
                        <titleInfo type="alternative">
                            <title><xsl:value-of select="."/></title>
                        </titleInfo>
                    </xsl:if>                  
                </xsl:when>
                <xsl:when test="@type='uniform'">
                    <xsl:if test="./title!=''">
                        <titleInfo type="uniform">
                            <title><xsl:value-of select="."/></title>
                        </titleInfo>
                    </xsl:if>                  
                </xsl:when>
                <xsl:otherwise>
                    <titleInfo>
                        <title><xsl:value-of select="."/></title>
                    </titleInfo>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
        
    <xsl:template match="originInfo">
        <originInfo eventType="publication">
            <!-- Dates -->
            <xsl:for-each select="dateIssued">
                <xsl:choose>
                    <xsl:when test="@keyDate='yes'">
                        <dateIssued keyDate="yes" encoding="w3cdtf"><xsl:value-of select="."/></dateIssued>                   
                    </xsl:when>
                    <xsl:otherwise>
                        <dateIssued><xsl:value-of select="."/></dateIssued>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <xsl:for-each select="copyrightDate">
                <copyrightDate><xsl:value-of select="."/></copyrightDate>
            </xsl:for-each>
            
            <!-- PUBLISHER -->
            <xsl:for-each select="publisher">
                <xsl:for-each select="tokenize(current(), '\| ')">
                    <publisher><xsl:value-of select='.'/></publisher>
                </xsl:for-each>
            </xsl:for-each>
            
            <xsl:apply-templates select="place"/>       
                        
            </originInfo>
        </xsl:template>
    
    <xsl:template match="place">
        <xsl:for-each select="placeTerm[@type='text']">
            <xsl:variable name="placeList" select="."/>
            <xsl:for-each select="tokenize(current(), '\| ')">
                <xsl:variable name="id-pos" select="position()"/>
                <place>
                    <placeTerm type="text">
                        <xsl:value-of select="."/>
                    </placeTerm>
                    <placeTerm authority="marccountry" type="code">
                        <xsl:value-of select="tokenize($placeList/following-sibling::placeTerm[@type='code'],'\| ')[position() = $id-pos]"/>
                    </placeTerm>
                </place>
        </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="identifier">
        
        <xsl:choose>
            <xsl:when test="@type='isbn'">
                <xsl:if test=". !=''">
                    <identifier type="isbn"><xsl:value-of select="."/></identifier>
                </xsl:if>                  
            </xsl:when>
            <xsl:when test="@type='issn'">
                <xsl:if test=". !=''">
                    <identifier type="issn"><xsl:value-of select="."/></identifier>
                </xsl:if>                  
            </xsl:when>
            <xsl:when test="@type='lcc'">
                <xsl:if test=". !=''">
                    <identifier type="lcc"><xsl:value-of select="."/></identifier>
                </xsl:if>                  
            </xsl:when>
            <xsl:when test="@type='oclc'">
                <xsl:if test=". !=''">
                    <identifier type="oclc"><xsl:value-of select="."/></identifier>
                </xsl:if>                  
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="language">
        <xsl:for-each select="languageTerm[@type='text']">
            <xsl:variable name="termList" select="."/>
            <xsl:for-each select="tokenize(., '\| ')">
                <xsl:variable name="id-pos" select="position()"/>
                <language>
                    <languageTerm type="text">
                        <xsl:value-of select="."/>
                    </languageTerm>
                    <languageTerm type="code" authority="iso639-2b">
                        <xsl:value-of select="tokenize($termList/following-sibling::languageTerm[@type='code'],'\| ')[position() = $id-pos]"/>
                    </languageTerm>
                </language>
            </xsl:for-each>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="physicalDescription">
        <physicalDescription>
            <extent><xsl:value-of select="extent"/></extent>
            
            <!-- materials -->
            <xsl:if test="form[@type='materials']='*'">
                <form type="materials"><xsl:value-of select="."/></form>
            </xsl:if>
            
            <!-- publication format -->
            <xsl:if test="form[@type='publication format']='*'">
                <xsl:for-each select="tokenize(current(), '\| ')">
                    <form type="publication format"><xsl:value-of select="."/></form>
                </xsl:for-each>
            </xsl:if>
            
            <!-- label transcription -->
            <xsl:for-each select="note[@type='label']">
                <note type="label"><xsl:value-of select="."/></note>
            </xsl:for-each>
            <xsl:for-each select="note[@type='handwriting']">
                <note type="handwriting"><xsl:value-of select="."/></note>
            </xsl:for-each>
            
            
        </physicalDescription>
    </xsl:template>
  
   
    <xsl:template match="genre">

            <xsl:for-each select="tokenize(current(), '\| ')">
                <genre><xsl:value-of select="."/></genre>
            </xsl:for-each>   
        
    </xsl:template>
    

</xsl:stylesheet>
