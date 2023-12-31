# Paso 1: Alcance del proyecto y captura de datos.

1. Identificar y recopilar los datos que usaras para tu proyecto.<br>
El [DataSet](https://www.kaggle.com/datasets/shivamb/bank-customer-segmentation) seleccionado es **Bank Customer Segmentation** contiene datos demográficos y de transacciones de clientes de un banco indio, este dataset tiene información como: 
- Fecha de nacimiento
- Género
- Ubicación
- Saldo de la cuenta
- Fecha de Transacción 
- Tiempo de transacción 
- Monto en INR

2. Explicar para qué casos de uso final deseas preparar los datos, por ejemplo: tabla de análisis, aplicación de fondo, base de datos de fuentes de verdad, etc.<br>
El caso de uso para el que prepararé los datos es para realizar **Análisis de comportamiento de gastos según la edad y género de los clientes**, el objetivo de este caso de uso será encontrar información valiosa sobre los patrones de gastos de diferentes grupos demográficos, esto nos puede ayudar a tomar decisiones estratégicas que podemos relacionar con la oferta de productos y servicios para los clientes.

# Paso 2: Explorar y evaluar los datos, el EDA.

En el notebook llamado "Paso2.ipynb" realizado en google colab se llevaron a cabo los siguientes pasos:

1. Importe las librerías necesarias.
2. Cargue los datos del dataset. 
3. Verifique la estructura del dataset, explore los tipos de datos con los que contamos.
4. Realice algunos cambios en el tipo de datos y cree algunas nuevas columnas calculadas.
5. Realice la eliminación de valores nulos del dataset.
6. Valide datos atípicos por cada una de las columnas.
7. Luego realice limpieza de los datos, eliminando por ejemplo edades que no tengan sentido, acotando los datos en edades entre 13 y 110 años, además de algunas otras limpiezas que se podrán validar en el notebook.
8. Finalmente elimine las columnas no necesarias y exporte el dataset resultante como un archivo csv.

Todos los pasos anteriores los fui explicando en el notebook mencionado.

# Paso 3: Definir el modelo de datos

1. Trazar el modelo de datos conceptual y explicar por qué se eligió ese modelo.

	![Modelo de datos conceptual](./images/modeloDeDatosConceptual.png)
	<br>
	Se eligió este modelo conceptual porque tiene una estructura clara y comprensible definiendo las entidades principales, que en este caso son el Cliente y la transacción, adicionalmente nos facilita la comprensión respecto a las relaciones entre las entidades y como se pueden consultar y analizar.  
	
2. Diseñar la arquitectura y los recursos utilizados.
	
	![Arquitectura](./images/arquitectura.png)
	<br>
3. Indique claramente los motivos de la elección de las herramientas y tecnologías para el proyecto.<br>
	Elegí herramientas como python, google colab porque python es el lenguaje recomendado por el documento de la prueba técnica y porque es un lenguaje que manejo bastante bien, el uso de google colab es debido a que me parece una herramienta sencilla de usar, que estoy acostumbrado a ella y me da la facilidad de tener un entorno aislado sin mucho esfuerzo.
	<br>
	Por otro lado respecto a las tecnologías y herramientas utilizadas para la creación y ejecución del ETL, Amazon S3 ofrece ventajas como una gran escalabilidad, economía y me permite modularidad en la arquitectura, por otro lado el uso de AWS Glue, permite que realice la transformación de los datos de forma sencilla con algunas transformaciones sencillas, pero a la vez me permite usar transformaciones a partir de SQL que son un poco más complejas, cosa que AWS Glue Databrew no me permite, adicionalmente son herramientas que me permiten realizar una buena integración con otras herramientas de AWS como Athena para explorar un poco más los datos y QuickSight para visualizar los mismos y también son herramientas que cuentan con mucha documentación y videos que podrían ayudar en caso de encontrarme con algún imprevisto.

4. Proponga con qué frecuencia deben actualizarse los datos y por qué.<br>
	La frecuencia de actualización de los datos depende de la disponibilidad y la actualización de los mismos, en este caso como estamos hablando de transacciones realizadas por los clientes de un banco lo más recomendable sería tener una actualización lo más cercano al tiempo real, es decir, en intervalos de pocos minutos o hasta segundos, para esto nos podríamos ayudar de los Schedules de los jobs en AWS Glue para ejecutar la transformación de los datos en los intervalos que sea necesario, pero en este caso como el objetivo del proyecto es el **Análisis de comportamiento de gastos según la edad y género de los clientes** no es primordial contar con la actualización de manera frecuente, en un principio se podrían realizar análisis con una muestra de los datos y posterior a ello cuando ya se tenga un análisis completamente estructurado, se pueden realizar actualizaciones periódicas.

# Paso 4: Ejecutar la ETL

Para la ejecución del ETL guarde los datos en un bucket S3.
![Bucket de S3](./images/bucketS3.png)

Despues realice la creación de la base de datos, la tabla que sería nuestro dataset y el crawler.

![Nequi base de datos](./images/nequiDatabase.png)
![Nequi Crawler](./images/nequiCrawler.png)

Esta es una vista de toda la transformación en general, para esta se realizó la limpieza de datos de forma similar a como lo hicimos en el archivo "Paso2.ipynb".

![Transformacion Completa](./images/transformacionCompleta.png)

Ya en glue studio extraje la información en dos dandole manejo a la información que es del cliente y la que es para transacciones.

![Doble Fuente](./images/dobleFuente.png)

Aquí se puede ver un poco de las consultas realizadas.

![Consultas Realizadas](./images/consultasRealizadas.png)

Posteriormente realice la unión a través de la columna CustomerID, para realizar el calculo de la edad de los clientes al momento de realizar la transacción.

![Creacion De Columna Edad](./images/creacionDeColumnaEdad.png)

Finalmente llevé la data procesada a un bucket de S3, en la imagen se puede ver que los datos llegaron correctamente formateados y con las columnas tal como las necesitamos.

![Ejecucion En S3](./images/ejecucionEnS3.png)

<br>

Para validar la calidad de los datos utilice la funcionalidad de AWS llamada precisamente "Data Quality", con esta funcionalidad realicé la definición de algunas reglas que validan la información arrojada por la tabla generada luego de ejecutar transformaciones.

![Data Quality](./images/calidadDatos.png)

<br>

Para el control de calidad en los datos con la integridad en la base de datos relacional, necesitaría usar efectivamente una base de datos relacional, como RDS por ejemplo, pero para este proyecto en especifico no fue necesario utilizar dicha base de datos y las herramientas utilizadas no proporcionan de manera nativa todas las caracteristicas de control de calidad e integridad que utilizamos en una base de datos relacional.
<br>
Pero es importante aclarar que para el caso de los clientes su identificador unico sería el customerID, para el caso de las transacciones el identificador unico sería el transactionID.
<br>
De igual manera ambas entidades se unen a través de del customerID, el cual sería una foreign keys en la entidad transacción.

<br>
En cuanto a la realización de pruebas de unidad para asegurar que se está haciendo lo correcto podríamos regresar a la funcionalidad de AWS llamada "Data Quality" que mencione anteriormente, ya que con esta funcionalidad podemos crear nosotros mismos una seríe de reglas para que se validen apartados especificos en nuestras tablas, como puede ser la existencia de columnas en especifico, unicidad de datos, validación de tipos de datos, entre otras cosas.

![Validación de los datos](./images/validacionDatos.png)

<br>

La validación de fuentes y conteos, la podemos realizar desde Amazon Athena despues de la ejecución de las transformaciones y antes de la misma comparando los datos de origen para garantizar que no haya pérdida de datos durante el proceso de extracción, también podemos hacer conteo de registros para detectar perdida o duplicación de datos durante el ETL, adicionalmente también podemos realizar totalizaciones y sumas de los valores numericos que tenemos para validar diferencias.

<br>

El diccionario de datos lo podemos crear con AWS Glue Data Catalog y validar en Amazon Athena, nos permite tener una visión de la estructura y los atributos de los datos que tenemos.

![Diccionario de datos](./images/diccionarioDeDatos.png)


# Paso 5: Completar la redacción del proyecto

1. ¿Cuál es el objetivo del proyecto?<br>
	El objetivo de este proyecto es encontrar información valiosa sobre los patrones de gastos de diferentes grupos demográficos, a partir de un dataset que alberga la información acerca de las transacciones realizadas por clientes de un banco indio.
2. ¿Qué preguntas quieres hacer?
	- ¿Hay alguna relación entre la ubicación geográfica de los clientes y sus patrones de gastos?
	- ¿Existe alguna diferencia significativa en los patrones de gastos entre hombres y mujeres?
	- ¿Hay alguna correlación entre el saldo de la cuenta de los clientes y sus patrones de gastos según su edad y género?
	- ¿Cuáles son las transacciones de mayor valor en términos de gastos y quiénes son los clientes que las realizaron?
	- ¿Cuáles son los grupos de edad que realizan los gastos más altos?
	- ¿Cuál es la distribución de gastos según la edad y el género de los clientes?
3.  ¿Por qué eligió el modelo que eligió?<br>
	Tal como indiqué anteriormente la elección de este modelo se debe a que nos permite varias cosas.
	- **Separar las preocupaciones** ya que cada entidad tiene sus propias relaciones y propiedades, esto facilita entender mejor la información al momento de analizar los datos.
	- Genera beneficios en cuanto a **simplicidad y claridad** ya que al tener dos entidades pequeñas ayuda a tener un modelo de datos un poco más simple.
	- Ayuda a no tener **redundancia de datos**, dado que si por ejemplo un cliente tiene varias transacciones no se va a repetir toda la información del cliente cada vez, se tendrá solo la información relevante de la transacción en este caso.
	- Permite **flexibilidad y escalabilidad** debido a que por ejemplo se podrían agregar entidades adicionales como productos o categorías de transacciones para analizar mejor que patrones de gastos tienen los clientes.
	- **Facilita el análisis de la información** de los clientes y las transacciones por separado.

4. Diferentes escenarios:
	- Si los datos se incrementaran en 100x<br>
	Primero que todo se tiene que contar con infraestructura escalable para poder manejar grandes volumenens de datos, luego tendría que validar que las consultar realizadas durante el proceso de ETL efectivamente sean lo más eficientes posibles, debería buscar la posibilidad de distribuir el procesamiento de los datos en paralelo. Adicionalmente se tendría que validar si toda la información es necesaria para el analisis o no para realizar filtrados de información.<br>
	
	- Si las tuberías se ejecutaran diariamente en una ventana de tiempo especifica.<br>
	Se debe iniciar por la priorización de tareas, es decir, si tenemos tareas de extracción que pueden llevar mucho más tiempo se debe empezar con estas en la ventana de tiempo asignada, por ello debemos considerar y medir el tiempo necesario para las etapas de extracción, transformación y carga, tambien se debe pensar en la paralelización de tareas, si es posible ejecutar transformaciónes al mismo tiempo sin que afecten los resultados finales, lo mejor es realizarlo y por ultimo se debe contar con un mecanismo de monitorización, alertas y control de errores para siempre estar al tanto de como está llevandose todo a cabo.

	<br>

	- Si la base de datos necesitara ser accedido por más de 100 usuarios funcionales.<br>
	Abordar esta situación implica dimensionar adecuadamente la infraestructura, como ya lo he dicho en un punto anterior, se debe contar con infraestructura escalable, implementar medidas de seguridad y controles de acceso de forma que los usuarios que accedan si sean quienes deben hacerlo y que tengan acceso a la información que les compete, tambien se debe optimizar el rendimiento y establecer un monitoreo continuo. Además, es importante asegurarse de proporcionar formación y soporte adecuados para los usuarios.

	<br>

	- Si se requiere hacer analítica en tiempo real, ¿cuales componentes cambiaria a su arquitectura propuesta?<br>
	Se podría realizar cambios en el almacenamiento para usar Amazon DynamoDB, esta base de datos está diseñada para ofrecer baja latencia y alta velocidad de escritura y lectura entonces es perfecta para analisis en tiempo real. En cuanto al procesamiento de los datos se podría usar AWS Kinesis ya que permite recibir datos continuamente en tiempo real.