package de.fhpotsdam.unfolding.providers;

import de.fhpotsdam.unfolding.core.Coordinate;
import de.fhpotsdam.unfolding.geo.MercatorProjection;
import de.fhpotsdam.unfolding.geo.Transformation;

/**
 * Various map tiles from OpenStreetMap.
 */
public class OpenStreetMap {
	public static abstract class GenericOpenStreetMapProvider extends AbstractMapTileUrlProvider {

		public GenericOpenStreetMapProvider() {
			super(new MercatorProjection(26, new Transformation(1.068070779e7, 0.0, 3.355443185e7, 0.0,
					-1.068070890e7, 3.355443057e7)));
		}

		public String getZoomString(Coordinate coordinate) {
			return (int) coordinate.zoom + "/" + (int) coordinate.column + "/" + (int) coordinate.row;
		}

		public int tileWidth() {
			return 256;
		}

		public int tileHeight() {
			return 256;
		}

		public abstract String[] getTileUrls(Coordinate coordinate);
	}

	public static class OpenStreetMapProvider extends GenericOpenStreetMapProvider {
		public String[] getTileUrls(Coordinate coordinate) {
			String url = "http://tile.openstreetmap.org/" + getZoomString(coordinate) + ".png";
			return new String[] { url };
		}
	}


}
