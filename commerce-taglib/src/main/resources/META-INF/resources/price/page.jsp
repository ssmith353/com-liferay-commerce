<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/price/init.jsp" %>

<%
CommerceDiscountValue commerceDiscountValue = (CommerceDiscountValue)request.getAttribute("liferay-commerce:price:commerceDiscountValue");
CPInstance cpInstance = (CPInstance)request.getAttribute("liferay-commerce:price:cpInstance");
DecimalFormat decimalFormat = (DecimalFormat)request.getAttribute("liferay-commerce:price:decimalFormat");
boolean displayDiscountLevels = (boolean)request.getAttribute("liferay-commerce:price:displayDiscountLevels");
String discountLabel = (String)request.getAttribute("liferay-commerce:price:discountLabel");
String formattedPrice = (String)request.getAttribute("liferay-commerce:price:formattedPrice");
String formattedPromoPrice = (String)request.getAttribute("liferay-commerce:price:formattedPromoPrice");
String promoPriceLabel = (String)request.getAttribute("liferay-commerce:price:promoPriceLabel");
boolean showDiscount = (boolean)request.getAttribute("liferay-commerce:price:showDiscount");
boolean showDiscountAmount = (boolean)request.getAttribute("liferay-commerce:price:showDiscountAmount");
boolean showPercentage = (boolean)request.getAttribute("liferay-commerce:price:showPercentage");
boolean showPriceRange = (boolean)request.getAttribute("liferay-commerce:price:showPriceRange");
%>

<c:choose>
	<c:when test="<%= Validator.isNull(formattedPrice) %>">
	</c:when>
	<c:when test="<%= cpInstance == null %>">
		<span class="product-price">
			<c:if test="<%= !showPriceRange %>">
				<span class="product-price-label">
					<liferay-ui:message key="starting-at" />
				</span>
			</c:if>

			<%= formattedPrice %>
		</span>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="<%= showDiscount && Validator.isNotNull(formattedPromoPrice) %>">

				<table class="a-lineitem" style="font-size: 16px;font-weight: 500;">
					<tbody>
					<c:if test="<%= Validator.isNull(promoPriceLabel) %>">
						<tr style="font-size: 16px;font-weight: 500;">
							<td class="product-promo-price">List Price:</td>
							<td class="a-span12 a-color-secondary a-size-base">
								<del><%= formattedPrice %></del>
							</td>
						</tr>
					</c:if>

					<tr id="priceblock_ourprice_row">
						<td id="priceblock_ourprice_lbl" class="a-color-secondary a-size-base a-text-right a-nowrap" style="font-size: 16px;font-weight: 500; text-align: right!important;" >Price:</td>
						<td class="a-span12">
							<span class="product-price" style="color:#B12704;"><%= formattedPromoPrice %></span>
						</td>
					</tr>

				<c:if test="<%= commerceDiscountValue != null %>">

					<%
					CommerceMoney discountAmount = commerceDiscountValue.getDiscountAmount();
					%>

					<span class="commerce-discount">
						<%= Validator.isNull(discountLabel) ? StringPool.BLANK : discountLabel %>

						<c:if test="<%= showDiscountAmount %>">
							<span class="discount-amount"><%= HtmlUtil.escape(discountAmount.format(locale)) %></span>
						</c:if>

						<c:if test="<%= showPercentage %>">

							<%
							BigDecimal[] percentages = commerceDiscountValue.getPercentages();

							decimalFormat.setPositiveSuffix(StringPool.PERCENT);
							%>

							<c:choose>
								<c:when test="<%= displayDiscountLevels && !ArrayUtil.isEmpty(percentages) %>">
									<span class="discount-percentage-level1"><%= decimalFormat.format(percentages[0]) %></span>

									<c:if test="<%= percentages[1].compareTo(BigDecimal.ZERO) > 0 %>">
										<span class="discount-percentage-level2"><%= decimalFormat.format(percentages[1]) %></span>
									</c:if>

									<c:if test="<%= percentages[2].compareTo(BigDecimal.ZERO) > 0 %>">
										<span class="discount-percentage-level3"><%= decimalFormat.format(percentages[2]) %></span>
									</c:if>

									<c:if test="<%= percentages[3].compareTo(BigDecimal.ZERO) > 0 %>">
										<span class="discount-percentage-level4"><%= decimalFormat.format(percentages[3]) %></span>
									</c:if>
								</c:when>
								<c:otherwise>

								<tr id="regularprice_savings" style="font-size: 16px;font-weight: 500;">
								<td class="a-color-secondary a-size-base a-text-right a-nowrap" style="font-size: 16px;font-weight: 500;">You Save:</td>
								<td class="discount-percentage" style="color:#B12704;" ><%= decimalFormat.format(commerceDiscountValue.getDiscountPercentage()) %></td>
							</tr>
							<tr id="priceblock_snsupsell_row" class="aok-hidden">
								<td colspan="2">
					<span class="a-size-base a-color-price">
					</span>
								</td>
							</tr>
							</tbody>


								</c:otherwise>
							</c:choose>
						</c:if>
					</span>
				</c:if>
				</table>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="<%= Validator.isNotNull(formattedPromoPrice) %>">
						<span class="product-price"><%= formattedPromoPrice %></span>
					</c:when>
					<c:otherwise>
						<span class="product-price"><%= formattedPrice %></span>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

