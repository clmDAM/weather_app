class TraduccionDia {
  static const _locale = 'es';

  static String traducirDia(String dia) {
    return _traduccionesDias[_locale]![dia] ?? dia;
  }

  static String traducirMes(String mes) {
    return _traduccionesMeses[_locale]![mes] ?? mes;
  }

  static final Map<String, Map<String, String>> _traduccionesDias = {
    'es': {
      "Monday": "Lunes",
      "Tuesday": "Martes",
      "Wednesday": "Miércoles",
      "Thursday": "Jueves",
      "Friday": "Viernes",
      "Saturday": "Sábado",
      "Sunday": "Domingo"
    },
  };

  static final Map<String, Map<String, String>> _traduccionesMeses = {
    'es': {
      "January": "Enero",
      "February": "Febrero",
      "March": "Marzo",
      "April": "Abril",
      "May": "Mayo",
      "June": "Junio",
      "July": "Julio",
      "August": "Agosto",
      "September": "Septiembre",
      "October": "Octubre",
      "November": "Noviembre",
      "December": "Diciembre"
    },
  };
}