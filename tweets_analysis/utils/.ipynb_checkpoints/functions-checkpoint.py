import pandas as pd
import datetime as dt
from datetime import timedelta



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