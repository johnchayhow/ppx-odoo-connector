# Payment Portal Express — Odoo connector
#
# A DATA MODULE on purpose: the only Python files here are this manifest and an
# empty __init__.py, and everything else is XML records. That is what lets it be
# imported into Odoo Online, where custom Python cannot run — which is where
# most customers' Odoo lives. It installs normally on Odoo.sh and on-premise.
#
# Nothing in this module processes a payment. It adds a button that opens the
# invoice in the customer's Payment Portal Express account, and the portal does
# the rest. Card details never touch Odoo.
{
    'name': 'Payment Portal Express',
    'version': '20.0.1.0.0',
    'summary': 'Pay invoices online: a Pay via Portal button on invoices and customers',
    'description': """
Payment Portal Express
======================

Adds a **Pay via Portal** button to customer invoices and to customers.

Clicking it opens that invoice in your Payment Portal Express account, where
your customer can pay by card or bank transfer. The payment is written back to
Odoo against the invoice, with the convenience fee (if you charge one) as its
own invoice line.

Requires a Payment Portal Express account: https://paymentportalexpress.com

What this module adds
---------------------
* Two server actions, one for invoices and one for customers.
* A button in the invoice and customer form headers.
* A *Credit Card Fee* product, used when a convenience fee is charged.
* A one-click **Finish setup** action that completes the accounting
  configuration the portal needs.

No card data is stored in or passes through Odoo.
""",
    'author': 'Payment Portal Express',
    'website': 'https://paymentportalexpress.com',
    'support': 'support@paymentportalexpress.com',
    'category': 'Accounting/Payment',
    'license': 'LGPL-3',
    'depends': ['account'],
    'data': [
        'data/config_parameters.xml',
        'data/fee_product.xml',
        'data/server_actions.xml',
        'data/setup_action.xml',
        'data/views.xml',
        'data/menus.xml',
    ],
    'images': ['static/description/banner.png'],
    'installable': True,
    'application': False,
}
