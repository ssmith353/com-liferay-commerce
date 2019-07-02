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

package com.liferay.commerce.order.web.internal.asset;

import com.liferay.asset.kernel.model.BaseJSPAssetRenderer;
import com.liferay.commerce.constants.CommerceOrderConstants;
import com.liferay.commerce.model.CommerceAddress;
import com.liferay.commerce.model.CommerceCountry;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceRegion;
import com.liferay.commerce.order.web.internal.security.permission.resource.CommerceOrderPermission;
import com.liferay.petra.string.StringBundler;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.Phone;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortletProvider;
import com.liferay.portal.kernel.portlet.PortletProviderUtil;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.GroupLocalServiceUtil;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.ResourceBundleLoader;

import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletURL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Andrea Di Giorgi
 * @author Marco Leo
 */
public class CommerceOrderAssetRenderer
	extends BaseJSPAssetRenderer<CommerceOrder> {

	public CommerceOrderAssetRenderer(CommerceOrder commerceOrder) {
		_commerceOrder = commerceOrder;
	}

	@Override
	public CommerceOrder getAssetObject() {
		return _commerceOrder;
	}

	@Override
	public String getClassName() {
		return CommerceOrder.class.getName();
	}

	@Override
	public long getClassPK() {
		return _commerceOrder.getCommerceOrderId();
	}

	@Override
	public long getGroupId() {
		return _commerceOrder.getGroupId();
	}

	@Override
	public String getJspPath(
		HttpServletRequest httpServletRequest, String template) {

		return "/asset/full_content.jsp";
	}

	@Override
	public String getSummary(
		PortletRequest portletRequest, PortletResponse portletResponse) {

		String summary = StringPool.BLANK;

		StringBundler sb = new StringBundler(21);

		try {
			sb.append("Contact: ");

			User orderUser =
				UserLocalServiceUtil.fetchUser(_commerceOrder.getUserId());

			if (orderUser != null) {
				sb.append(orderUser.getFullName());
				sb.append(StringPool.NEW_LINE);
			}

			if (orderUser != null) {
				List<Phone> phones = orderUser.getPhones();

				if (!phones.isEmpty()) {
					Phone phone = phones.get(0);

					sb.append(phone.getNumber());

					sb.append(StringPool.NEW_LINE);
				}

				sb.append(orderUser.getEmailAddress());

				CommerceAddress commerceAddress =
					_commerceOrder.getShippingAddress();

				if (commerceAddress != null) {
					sb.append("Shipping: ");
					sb.append(commerceAddress.getStreet1());
					sb.append(StringPool.NEW_LINE);
					sb.append(commerceAddress.getCity());

					CommerceRegion commerceRegion =
						commerceAddress.getCommerceRegion();

					if (commerceRegion != null) {
						sb.append(StringPool.COMMA);
						sb.append(StringPool.SPACE);
						sb.append(commerceRegion.getName());
						sb.append(StringPool.SPACE);
						sb.append(commerceAddress.getZip());
						sb.append(StringPool.SPACE);
					}

					CommerceCountry commerceCountry =
						commerceAddress.getCommerceCountry();

					if (commerceCountry != null) {
						sb.append(StringPool.NEW_LINE);
						sb.append(
							commerceCountry.getName(
								LocaleUtil.getMostRelevantLocale()));
					}

					sb.append(StringPool.NEW_LINE);

				}
			}
		}
		catch (Exception e) {
		}
		finally {
			summary = sb.toString();
		}

		return summary;
	}

	@Override
	public String getTitle(Locale locale) {
		ResourceBundleLoader resourceBundleLoader = getResourceBundleLoader();

		ResourceBundle resourceBundle = resourceBundleLoader.loadResourceBundle(
			locale);

		return LanguageUtil.format(
			resourceBundle, "order-x", _commerceOrder.getCommerceOrderId());
	}

	@Override
	public String getURLViewInContext(
			LiferayPortletRequest liferayPortletRequest,
			LiferayPortletResponse liferayPortletResponse,
			String noSuchEntryRedirect)
		throws Exception {

		Group group = GroupLocalServiceUtil.getGroup(
			_commerceOrder.getGroupId());

		PortletURL portletURL = PortletProviderUtil.getPortletURL(
			liferayPortletRequest, group, CommerceOrder.class.getName(),
			PortletProvider.Action.VIEW);

		portletURL.setParameter(
			"mvcRenderCommandName", "viewCommerceOrderDetails");
		portletURL.setParameter(
			"commerceOrderId",
			String.valueOf(_commerceOrder.getCommerceOrderId()));

		return portletURL.toString();
	}

	@Override
	public long getUserId() {
		return _commerceOrder.getUserId();
	}

	@Override
	public String getUserName() {
		return _commerceOrder.getUserName();
	}

	@Override
	public String getUuid() {
		return _commerceOrder.getUuid();
	}

	@Override
	public boolean hasEditPermission(PermissionChecker permissionChecker)
		throws PortalException {

		return CommerceOrderPermission.contains(
			permissionChecker, _commerceOrder, ActionKeys.UPDATE);
	}

	@Override
	public boolean hasViewPermission(PermissionChecker permissionChecker)
		throws PortalException {

		return CommerceOrderPermission.contains(
			permissionChecker, _commerceOrder, ActionKeys.VIEW);
	}

	@Override
	public boolean include(
		HttpServletRequest request, HttpServletResponse response,
		String template)
		throws Exception {

		String summary = StringPool.BLANK;
		String address = StringPool.BLANK;

		StringBundler contactSummary = new StringBundler(21);

		long userId = _commerceOrder.getUserId();

		System.out.println("userId " + userId);

		try {
			User orderUser =
				UserLocalServiceUtil.fetchUser(_commerceOrder.getUserId());

			if (orderUser != null) {
				contactSummary.append(orderUser.getFullName());
				contactSummary.append("<br>");

				System.out.println("order user was not null");
			} else {
				System.out.println("order user was null");
			}

			if (orderUser != null) {
				List<Phone> phones = orderUser.getPhones();

				if (!phones.isEmpty()) {
					Phone phone = phones.get(0);

					contactSummary.append(phone.getNumber());

					contactSummary.append("<br>");
				}

				contactSummary.append("<a href=\"mailto:");
				contactSummary.append(orderUser.getEmailAddress());
				contactSummary.append("\">");
				contactSummary.append(orderUser.getEmailAddress());
				contactSummary.append("</a>");


			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			summary = contactSummary.toString();
		}

		StringBundler addressSummary = new StringBundler(21);

		try {
			CommerceAddress commerceAddress =
				_commerceOrder.getShippingAddress();

			if (commerceAddress != null) {
				addressSummary.append(commerceAddress.getStreet1());
				addressSummary.append("<br>");
				addressSummary.append(commerceAddress.getCity());

				CommerceRegion commerceRegion =
					commerceAddress.getCommerceRegion();

				if (commerceRegion != null) {
					addressSummary.append(StringPool.COMMA);
					addressSummary.append(StringPool.SPACE);
					addressSummary.append(commerceRegion.getName());
					addressSummary.append(StringPool.SPACE);
					addressSummary.append(commerceAddress.getZip());
					addressSummary.append(StringPool.SPACE);
				}

				CommerceCountry commerceCountry =
					commerceAddress.getCommerceCountry();

				if (commerceCountry != null) {
					addressSummary.append("<br>");
					addressSummary.append(
						commerceCountry.getName(
							LocaleUtil.getMostRelevantLocale()));
				}

				addressSummary.append("<br>");
			}
		} catch (Exception e) {

		} finally {
			address = addressSummary.toString();
		}

		request.setAttribute("ADDRESS", address);
		request.setAttribute("COMMERCE_ORDER", _commerceOrder);
		request.setAttribute("SUMMARY", summary);

		return super.include(request, response, template);
	}

	@Override
	public boolean isPreviewInContext() {
		return true;
	}

	private final CommerceOrder _commerceOrder;

}