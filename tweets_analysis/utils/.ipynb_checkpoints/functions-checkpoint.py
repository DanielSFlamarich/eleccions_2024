import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns

import datetime as dt
from datetime import timedelta



def dibuixar_countplot_amb_valors(data, column, ax, title, palette, percentage=True):
    """
    Plota un countplot amb comptatges i percentatges opcionals.

    Paràmetres:
    data (DataFrame): El conjunt de dades que conté la columna a plotejar.
    column (str): El nom de la columna que es vol plotejar.
    ax (Axes): Els eixos en els quals es plotejarà el gràfic.
    title (str): El títol del gràfic.
    percentage (bool): Si és True, es mostren comptatges i percentatges. Si és False, només es mostren comptatges. Valor per defecte és True.

    Exemple d'ús:
    fig, ax = plt.subplots()
    plot_countplot_with_counts_and_percentages(data=df, column='columna', ax=ax, title='Títol del Gràfic', palette=palette, percentage=True)
    plt.show()
    """
    total = len(data)
    sns.countplot(y=column, data=data, order=data[column].value_counts().index, ax=ax, palette=palette)
    for p in ax.patches:
        width = p.get_width()
        if percentage:
            percent_text = f' ({(width / total) * 100:.1f}%)'
        else:
            percent_text = ''
        ax.text(width + 1, p.get_y() + p.get_height() / 2, f'{int(width)}{percent_text}', ha='left', va='center')
    ax.set_title(title)



def crear_metrica_taxa(df, metric):
    # comprovar que ambdues mètriques necessàries existeixen: 
    if metric in df.columns and 'seguiment' in df.columns:
        # calcular la taxa per 1,000 seguidors
        df.loc[: , f'taxa_{metric}'] = (df[metric] / df['seguiment']) * 1000
    else:
        # mostrar missatge error en cas que
        print(f"Error: Alguna de les dues mètriques '{metric}' i/o 'seguiment' no existeixen com a columnes al dataset.")
    return df


def activity_level(df, window):
    '''
    Takes a time window, counts members within it.
    Returns: Average days of login during chosen window.
    '''
    df[['first_log_date', 'logged_date']] = df[['first_logged_at', 'logged_at']].values.astype('datetime64[D]')
    df.drop_duplicates(subset=['email', 'logged_date'], keep='first', inplace=True)
    
    time_window = (df['first_log_date'] + timedelta(days=window))
    members = df['membership_id'].nunique()
    act_level = df[df['logged_date']<time_window]['logged_date'].count()
    return act_level/members