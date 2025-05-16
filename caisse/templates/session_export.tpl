{if $print}
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>{$title}</title>
	<style type="text/css">
	{literal}
	body {
		font-family: sans-serif;
		font-size: 11pt;
		background: #fff;
	}

	.error {
		color: darkred;
		border: 3px double #666;
	}

	h1 {
		font-size: 1.3em;
		text-align: center;
	}

	h2 {
		font-size: 1.2em;
		text-align: center;
	}

	.noprint {
		display: none;
	}

	th, b {
		font-weight: inherit;
	}

	table.list {
		margin: 0.5em auto;
		border-collapse: collapse;
		break-inside: avoid;
	}

	table.list th, table.list td {
		padding: .2em .4em;
		border: 1px solid #666;
		text-align: left;
	}

	table.list thead td, table.list thead th, table.list tfoot th, table.list tfoot td {
		background: #ccc;
		font-weight: bold;
	}

	.actions {
		display: none;
	}

	.details {
		text-align: center;
	}
	{/literal}
	</style>
</head>

<body>
<h1>{$title}</h1>
{/if}


{if $pos_session.error_amount}
	<p class="error block">Erreur de {$pos_session.error_amount|raw|money_currency}</span>
{/if}

<p class="details">
	Ouverture&nbsp;: {$pos_session.opened|date}
	— par {$pos_session.open_user}
	— Caisse = {$pos_session.open_amount|raw|money_currency}
</p>
<p class="details">
	Fermeture&nbsp;:
	{if !$pos_session.closed}<strong>En cours</strong>
	{else}{$pos_session.closed|date}
		— par {$pos_session.close_user}
		— Caisse = {$pos_session.close_amount|raw|money_currency}
		{if !$pos_session.error_amount}
			— pas d'erreur
		{/if}
	{/if}
</p>

<h2 class="ruler">Totaux des règlements, par moyen de paiement</h2>

<table class="list">
	<thead>
		<tr>
			<td>Moyen</td>
			<td>Montant</td>
		</tr>
	</thead>
	<tbody>
		{foreach from=$payments_totals item="payment"}
		<tr>
			<th>{$payment.method_name}</th>
			<td>
				{$payment.total|raw|money_currency:false}
			</td>
		</tr>
		{/foreach}
	</tbody>
</table>

<h2 class="ruler">Ventes par catégorie</h2>

<table class="list">
	<thead>
		<tr>
			<td>Compte</td>
			<td>Catégorie</td>
			<td>Montant</td>
			<td>Nombre de ventes</td>
			<td>Poids</td>
		</tr>
	</thead>
	<tbody>
		<?php $count = $weight = 0; ?>
		{foreach from=$totals_categories item="cat"}
		<tr>
			<td>{$cat.account}</td>
			<th>{$cat.category_name}</th>
			<td>
				{$cat.total|raw|money_currency:false}
			</td>
			<td>{$cat.count}</td>
			<td>{$cat.weight|weight:false:true}</td>
		</tr>
		<?php $count += $cat->count; $weight += $cat->weight; ?>
		{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<th>Total</th>
			<td>{$total_sales|raw|money_currency:false}</td>
			<td>{$count}</td>
			<td>{$weight|weight:false:true}</td>
		</tr>
	</tfoot>
</table>

<h2 class="ruler">Ventes par produit</h2>

<table class="list">
	<thead>
		<tr>
			<td>Catégorie</td>
			<td>Produit</td>
			<td>Montant</td>
			<td>Nombre de ventes</td>
			<td>Poids</td>
		</tr>
	</thead>
	<tbody>
		<?php $count = $weight = 0; ?>
		{foreach from=$totals_products item="p"}
		<tr>
			<td>{$p.category_name}</td>
			<th>{$p.name}</th>
			<td>
				{$p.total|raw|money_currency:false}
			</td>
			<td>{$p.count}</td>
			<td>{$p.weight|weight:false:true}</td>
		</tr>
		<?php $count += $p->count; $weight += $p->weight; ?>
		{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<th>Total</th>
			<td>{$total_sales|raw|money_currency:false}</td>
			<td>{$count}</td>
			<td>{$weight|weight:false:true}</td>
		</tr>
	</tfoot>
</table>


<h2 class="ruler">Liste des règlements</h2>

<table class="list">
	<thead>
		<tr>
			<td>Note n°</td>
			<th>Heure</th>
			<td>Moyen</td>
			<td>Montant</td>
			<td>Référence</td>
			<td class="actions"></td>
		</tr>
	</thead>
	<tbody>
		{foreach from=$payments item="payment"}
		<tr>
			<td>{$payment.tab}{if $payment.tab_name} — {$payment.tab_name}{/if}</td>
			<th>
				{$payment.date|date_hour}
			</th>
			<td>{$payment.method_name}</td>
			<td>
				{$payment.amount|raw|money_currency:false}
			</td>
			<td>{$payment.reference}</td>
			<td class="actions">
				{linkbutton shape="menu" label="Détails" href="tab.php?id=%d"|args:$payment.tab class="noprint"}
			</td>
		</tr>
		{/foreach}
	</tbody>
</table>

<h2 class="ruler">Liste des notes</h2>

<table class="list">
	<thead>
		<tr>
			<td>N°</td>
			<th>Heure</th>
			<td>Total</td>
			<td class="actions"></td>
		</tr>
	</thead>
	<tbody>
		{foreach from=$tabs item="tab"}
		<tr>
			<td>{$tab.id}{if $tab.name} — {$tab.name}{/if}</td>
			<th>
				{$tab.opened|date_hour}
				{if $tab.closed}
				&rarr; {$tab.closed|date_hour}
				{/if}
			</th>
			<td>
				{$tab.total|raw|money_currency:false}
			</td>
			<td class="actions">
				{if $tab.user_id}
					{linkbutton shape="user" label="Fiche membre" href="!users/details.php?id=%d"|args:$tab.user_id class="noprint"}
				{/if}
				{linkbutton shape="menu" label="Détails" href="tab.php?id=%d"|args:$tab.id class="noprint"}
			</td>
		</tr>
		{/foreach}
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<th>Total</th>
			<td>{$total_payments|raw|money_currency:false}</td>
			<td class="actions"></td>
		</tr>
	</tfoot>
</table>

{if $details}

{foreach from=$tabs item="tab"}

	<h2 class="ruler">Note n°{$tab.id}&nbsp;:
		{$tab.opened|date_hour}
		{if $tab.closed}
		&rarr; {$tab.closed|date_hour}
		{/if}
		— {$tab.name}
	</h2>

	<section class="items">
		<table class="list">
			<thead>
				<td>Catégorie</td>
				<th>Produit</th>
				<td>Qté</td>
				<td>Prix</td>
				<td>Total</td>
			</thead>
			<tbody>
			{foreach from=$tab.items item="item"}
			<tr>
				<td>{$item.category_name}</td>
				<th>{$item.name}</th>
				<td>{$item.qty}</td>
				<td>{$item.price|raw|money_currency:false}</td>
				<td>{$item.total|raw|money_currency:false}</td>
			</tr>
			{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<th>Total</th>
					<td></td>
					<td></td>
					<td>{$tab.total|raw|money_currency:false}</td>
				</tr>
			</tfoot>
		</table>
	</section>

{/foreach}

{/if}

{if $print}
</body>
</html>
{/if}