app.displayDialogs = DialogModes.NO;

// Configuración de rutas (modifícalas según tus carpetas)
var baseFolder = Folder("C:/Users/monsi/Desktop/ROL/02. Creación de Fichas, Recortes, Tarjetas, PJ, PNJ");
var numbersFolder = Folder("C:/Users/monsi/Desktop/ROL/02. Creación de Fichas, Recortes, Tarjetas, PJ, PNJ/00. PSD");
var outputFolder = Folder(baseFolder + "/Exported");

if (!outputFolder.exists) outputFolder.create();

var numberFiles = [];
for (var i = 1; i <= 10; i++) {
    numberFiles.push("Recorte (" + i + ").psd");
}

function openFile(folder, filename) {
    var fileRef = File(folder + "/" + filename);
    if (fileRef.exists) {
        return app.open(fileRef);
    } else {
        alert("No se encontró el archivo: " + filename);
        return null;
    }
}

function getVisibleLayer(doc) {
    for (var i = 0; i < doc.layers.length; i++) {
        var layer = doc.layers[i];
        if (layer.visible) return layer;
    }
    return null;
}

function savePNG(doc, filePath) {
    var opts = new PNGSaveOptions();
    doc.saveAs(File(filePath), opts, true, Extension.LOWERCASE);
}

var baseFiles = baseFolder.getFiles(function(f) {
    return f instanceof File && /\.(psd|png|jpg|jpeg)$/i.test(f.name);
});

if (baseFiles.length == 0) {
    alert("No se encontraron imágenes en la carpeta base.");
} else {
    for (var b = 0; b < baseFiles.length; b++) {
        var baseDoc = app.open(baseFiles[b]);

        for (var n = 0; n < numberFiles.length; n++) {
            var numberDoc = openFile(numbersFolder, numberFiles[n]);
            if (numberDoc == null) continue;

            var visibleLayer = getVisibleLayer(numberDoc);
            if (!visibleLayer) {
                alert("No se encontró capa visible en " + numberFiles[n]);
                numberDoc.close(SaveOptions.DONOTSAVECHANGES);
                continue;
            }

            visibleLayer.duplicate(baseDoc, ElementPlacement.PLACEATBEGINNING);

            numberDoc.close(SaveOptions.DONOTSAVECHANGES);

            var baseName = baseFiles[b].name.replace(/\.[^\.]+$/, '');
            var numberSuffix = "_n" + (n + 1);
            var savePath = outputFolder + "/" + baseName + numberSuffix + ".png";
            savePNG(baseDoc, savePath);

            baseDoc.activeLayer.remove();
        }

        baseDoc.close(SaveOptions.DONOTSAVECHANGES);
    }
    alert("Proceso terminado. Archivos guardados en:\n" + outputFolder.fsName);
}

app.displayDialogs = DialogModes.ALL;
